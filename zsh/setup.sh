#!/usr/bin/env bash
# oh-my-zsh and its plugins, the machine-local ZDOTDIR stubs, and moving old history to XDG state.
source "${DOTCONFIG:-$HOME/dotconfig}/lib/dot.sh"

zdotdir="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
state="${XDG_STATE_HOME:-$HOME/.local/state}/zsh"

if [[ ! -d $HOME/.oh-my-zsh ]]; then
  dot_log "install oh-my-zsh"
  dot_run env RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# oh-my-zsh custom plugin name -> repository
plugins=(
  "auto-notify https://github.com/MichaelAquilina/zsh-auto-notify.git"
  "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git"
  "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git"
  "zsh-completions https://github.com/zsh-users/zsh-completions.git"
  # Alternative highlighter (enable one, never both):
  # "fast-syntax-highlighting https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
)
custom="$HOME/.oh-my-zsh/custom/plugins"
for entry in "${plugins[@]}"; do
  read -r name url <<<"$entry"
  if [[ -d $custom/$name/.git ]]; then
    dot_run git -C "$custom/$name" pull --quiet --ff-only
  else
    dot_log "clone $name"
    dot_run git clone --quiet --depth 1 "$url" "$custom/$name"
  fi
done

# Local stubs: created once, never overwritten, since they hold this machine's own lines.
for f in .zprofile .zshrc .zlogin; do
  if [[ ! -f $zdotdir/$f ]]; then
    dot_log "create ${zdotdir/#$HOME/~}/$f"
    dot_run mkdir -p "$zdotdir"
    dot_run cp "$DOTCONFIG/zsh/stub/$f" "$zdotdir/$f"
  fi
done
if [[ ! -f $zdotdir/secrets.zsh ]]; then
  dot_run install -m 600 /dev/null "$zdotdir/secrets.zsh"
fi

# History used to live in the repo (macOS) or ~/.zsh_history; keep the larger one.
if [[ ! -s $state/history ]]; then
  old=""
  for candidate in "$DOTCONFIG/zsh/.zsh_history" "$HOME/.zsh_history"; do
    [[ -s $candidate ]] || continue
    if [[ -z $old ]] || (( $(wc -c <"$candidate") > $(wc -c <"$old") )); then
      old=$candidate
    fi
  done
  if [[ -n $old ]]; then
    dot_log "move history ${old/#$HOME/~} -> ${state/#$HOME/~}/history"
    dot_run mkdir -p "$state"
    dot_run cp -p "$old" "$state/history"
  fi
fi

if [[ $(basename "${SHELL:-}") != zsh ]]; then
  dot_warn "login shell is ${SHELL:-unknown}; switch with: chsh -s \"$(command -v zsh)\""
fi
