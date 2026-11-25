#!/usr/bin/env bash
# Helpers shared by bootstrap.sh and module setup.sh hooks. Every helper is idempotent and honours
# DOT_DRY_RUN=1 (print what would change, change nothing).

DOTCONFIG="${DOTCONFIG:-$HOME/dotconfig}"
DOT_LOCAL="${XDG_CONFIG_HOME:-$HOME/.config}/dotconfig"
DOT_DRY_RUN="${DOT_DRY_RUN:-0}"

dot_os() {
  case "$(uname -s)" in
    Darwin) echo mac ;;
    Linux) echo linux ;;
    *) echo unknown ;;
  esac
}

dot_log() { printf '  %s\n' "$*"; }
dot_step() { printf '\n==> %s\n' "$*"; }
dot_warn() { printf '  ! %s\n' "$*" >&2; }

# Run a command, or only show it in a dry run.
dot_run() {
  if [[ $DOT_DRY_RUN == 1 ]]; then
    dot_log "would run: $*"
  else
    "$@"
  fi
}

dot_have() { command -v "$1" >/dev/null 2>&1; }

# Non-comment, non-blank lines of a manifest, with trailing comments stripped.
dot_lines() {
  [[ -f $1 ]] || return 0
  sed -e 's/[[:space:]]*#.*$//' -e '/^[[:space:]]*$/d' "$1"
}

# True when an os tag (any, mac, linux; empty means any) matches this machine.
dot_os_matches() {
  [[ -z $1 || $1 == any || $1 == "$(dot_os)" ]]
}

# Link $1 (absolute) to $2 (~ allowed). A correct link is left alone; a real file or a wrong link
# is moved to <dst>.bak-<timestamp> first. Mode "root-copy" copies as root instead, for paths root
# owns (such as /etc), where a link into $HOME is wrong.
dot_link() {
  local src=$1 dst=${2/#\~/$HOME} mode=${3:-link} as=() verb=link
  if [[ $mode == root-copy ]]; then
    as=(sudo)
    verb=copy
  fi
  if [[ ! -e $src ]]; then
    dot_warn "missing source ${src/#$HOME/~}"
    return 1
  fi
  if [[ $verb == link && -L $dst && $(readlink "$dst") == "$src" ]]; then
    return 0
  fi
  if [[ $verb == copy && -f $dst ]] && cmp -s "$src" "$dst"; then
    return 0
  fi
  if [[ -e $dst || -L $dst ]]; then
    local backup
    backup="$dst.bak-$(date +%Y%m%d%H%M%S)"
    dot_log "back up ${dst/#$HOME/~} -> ${backup/#$HOME/~}"
    dot_run "${as[@]}" mv "$dst" "$backup"
  fi
  dot_log "$verb ${dst/#$HOME/~} <- ${src/#$HOME/~}"
  dot_run "${as[@]}" mkdir -p "$(dirname "$dst")"
  if [[ $verb == copy ]]; then
    dot_run "${as[@]}" cp "$src" "$dst"
  else
    dot_run ln -s "$src" "$dst"
  fi
}

# Enabled modules in order: the repo's modules list filtered by OS, then the machine-local
# $DOT_LOCAL/modules, whose "+name" lines add a module and "-name" lines skip one.
dot_modules() {
  local name os enabled=() kept=() m
  while read -r name os; do
    dot_os_matches "$os" && enabled+=("$name")
  done < <(dot_lines "$DOTCONFIG/modules")
  while read -r name _; do
    case $name in
      +*) [[ " ${enabled[*]} " == *" ${name#+} "* ]] || enabled+=("${name#+}") ;;
      -*)
        kept=()
        for m in "${enabled[@]}"; do
          [[ $m == "${name#-}" ]] || kept+=("$m")
        done
        enabled=("${kept[@]}")
        ;;
    esac
  done < <(dot_lines "$DOT_LOCAL/modules")
  printf '%s\n' "${enabled[@]}"
}

# Packages a module declares for one manager: brew, cask (Mac), pacman, aur (Arch).
dot_module_packages() {
  local module=$1 manager=$2 entry
  while read -r entry _; do
    [[ $entry == "$manager:"* ]] && echo "${entry#*:}"
  done < <(dot_lines "$DOTCONFIG/$module/packages")
  return 0
}
