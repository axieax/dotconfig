#!/usr/bin/env bash
# Set up this machine from the repo; safe to re-run. Each enabled module (see `modules`) may have:
#   packages  "brew:x" / "cask:x" (Mac), "pacman:x" / "aur:x" (Arch) lines
#   mise.toml tools for that module, linked into ~/.config/mise/conf.d/
#   links     "source | destination [| os [| root-copy]]" lines, source relative to the module
#   setup.sh  extra idempotent steps (run last)
# Machine-local: ~/.config/dotconfig/modules ("+name"/"-name") and ~/.config/dotconfig/hooks/*.sh.
#
#   ./bootstrap.sh                    everything, for every enabled module
#   ./bootstrap.sh --dry-run          show what would change
#   ./bootstrap.sh --only=links,hooks run some steps: prereqs, packages, mise, links, hooks
#   ./bootstrap.sh zsh tmux           only these modules
#   ./bootstrap.sh --list             enabled modules on this machine
set -eo pipefail  # no -u: macOS ships bash 3.2, where it rejects empty arrays

export DOTCONFIG="${DOTCONFIG:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
# shellcheck source=lib/dot.sh
source "$DOTCONFIG/lib/dot.sh"

steps="prereqs,packages,mise,links,hooks"
only_modules=()
for arg in "$@"; do
  case $arg in
    --dry-run) export DOT_DRY_RUN=1 ;;
    --only=*) steps=${arg#--only=} ;;
    --list) dot_modules; exit 0 ;;
    -h | --help) sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*) dot_warn "unknown option $arg"; exit 2 ;;
    *) only_modules+=("$arg") ;;
  esac
done

modules=()
while read -r m; do
  if [[ ${#only_modules[@]} -eq 0 || " ${only_modules[*]} " == *" $m "* ]]; then
    modules+=("$m")
  fi
done < <(dot_modules)

want() { [[ ",$steps," == *",$1,"* ]]; }

mise_bin() { command -v mise || echo "$HOME/.local/bin/mise"; }

step_prereqs() {
  dot_step "prerequisites"
  if [[ $(dot_os) == mac ]] && ! dot_have brew; then
    dot_run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  if [[ ! -x $(mise_bin) ]]; then
    if [[ $(dot_os) == mac ]]; then
      dot_run brew install mise
    else
      # The standalone binary in ~/.local/bin, so `mise self-update` works.
      dot_run sh -c "curl -fsSL https://mise.run | sh"
    fi
  fi
}

step_packages() {
  dot_step "packages"
  local m p
  if [[ $(dot_os) == mac ]]; then
    local brewfile="" casks=() app
    for m in "${modules[@]}"; do
      while read -r p; do brewfile+="brew \"$p\""$'\n'; done < <(dot_module_packages "$m" brew)
      while read -r p; do casks+=("$p"); done < <(dot_module_packages "$m" cask)
    done
    # brew refuses to install a cask over an app installed by hand, so such an app counts as
    # installed; --adopt brings it under brew without reinstalling it.
    for p in "${casks[@]}"; do
      if ! brew list --cask "$p" >/dev/null 2>&1; then
        app=$(brew info --cask --json=v2 "$p" 2>/dev/null | tr -d '\n' |
          grep -o '"app": *\[ *"[^"]*' | head -1 | sed 's/.*"//')
        if [[ -n $app && -d /Applications/$app ]]; then
          dot_log "$app was installed by hand; to let brew manage it: brew install --cask --adopt $p"
          continue
        fi
      fi
      brewfile+="cask \"$p\""$'\n'
    done
    [[ -z $brewfile ]] && return 0
    if brew bundle check --no-upgrade --file=- <<<"$brewfile" >/dev/null 2>&1; then
      dot_log "all Homebrew packages installed"
    elif [[ $DOT_DRY_RUN == 1 ]]; then
      dot_log "would install missing Homebrew packages:"
      brew bundle list --all --file=- <<<"$brewfile" | while read -r p; do
        brew list "$p" >/dev/null 2>&1 || dot_log "  $p"
      done
    else
      brew bundle install --no-upgrade --file=- <<<"$brewfile"
    fi
  else
    local manager missing helper
    for manager in pacman aur; do
      missing=()
      for m in "${modules[@]}"; do
        while read -r p; do
          pacman -Qq "$p" >/dev/null 2>&1 || missing+=("$p")
        done < <(dot_module_packages "$m" "$manager")
      done
      [[ ${#missing[@]} -eq 0 ]] && continue
      if [[ $manager == pacman ]]; then
        dot_run sudo pacman -S --needed --noconfirm "${missing[@]}"
      else
        helper=$(command -v paru || command -v yay || true)
        if [[ -z $helper ]]; then
          dot_warn "no AUR helper (paru or yay); skipped: ${missing[*]}"
          continue
        fi
        dot_run "$helper" -S --needed --noconfirm "${missing[@]}"
      fi
    done
    [[ $DOT_DRY_RUN == 1 ]] || dot_log "all Arch packages installed"
  fi
}

step_mise() {
  dot_step "mise tools"
  local m
  for m in "${modules[@]}"; do
    [[ -f $DOTCONFIG/$m/mise.toml ]] &&
      dot_link "$DOTCONFIG/$m/mise.toml" "~/.config/mise/conf.d/$m.toml"
  done
  dot_run "$(mise_bin)" install --yes
}

step_links() {
  dot_step "links"
  local m src dst os mode
  for m in "${modules[@]}"; do
    while IFS='|' read -r src dst os mode; do
      src=$(xargs <<<"$src") dst=$(sed -e 's/^ *//' -e 's/ *$//' <<<"$dst")
      os=$(xargs <<<"${os:-}") mode=$(xargs <<<"${mode:-}")
      dot_os_matches "$os" || continue
      # Absolute and without "..", so an existing link compares equal.
      if [[ $src == . ]]; then
        src="$DOTCONFIG/$m"
      else
        src="$(cd "$DOTCONFIG/$m/$(dirname "$src")" && pwd)/$(basename "$src")"
      fi
      dot_link "$src" "$dst" "${mode:-link}"
    done < <(dot_lines "$DOTCONFIG/$m/links")
  done
}

step_hooks() {
  dot_step "module setup"
  local m h
  for m in "${modules[@]}"; do
    if [[ -f $DOTCONFIG/$m/setup.sh ]]; then
      dot_log "[$m]"
      bash "$DOTCONFIG/$m/setup.sh" || failed+=("$m")
    fi
  done
  # Machine-local extras (things this machine needs that the repo should not carry).
  for h in "$DOT_LOCAL"/hooks/*.sh; do
    [[ -f $h ]] || continue
    dot_log "[local] ${h/#$HOME/~}"
    bash "$h" || failed+=("local:$(basename "$h")")
  done
}

# Hooks run the tools a login shell would: ~/.local/bin, where mise, t3, Claude Code and Codex
# install their commands, then mise's shims first (Arch's own python3 refuses pip installs).
use_mise_shims() {
  local shims="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims"
  [[ -d $HOME/.local/bin ]] && export PATH="$HOME/.local/bin:$PATH"
  [[ -d $shims ]] && export PATH="$shims:$PATH"
  return 0
}

failed=()
dot_log "modules: ${modules[*]}"
use_mise_shims
for s in prereqs packages mise links hooks; do
  if want "$s"; then
    "step_$s"
    [[ $s == prereqs ]] && use_mise_shims
  fi
done
if [[ ${#failed[@]} -gt 0 ]]; then
  dot_warn "setup failed for: ${failed[*]}"
  exit 1
fi
dot_step "done"
