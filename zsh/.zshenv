# The one zsh file that must live in $HOME (linked to ~/.zshenv). It points zsh at the machine-local
# ZDOTDIR, whose stub files load this repo; see zsh/README.md. XDG locations per
# https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export DOTCONFIG="${DOTCONFIG:-$HOME/dotconfig}"
# Until bootstrap.sh creates the local stubs, use the repo's copies so no shell starts bare.
if [[ -f "$XDG_CONFIG_HOME/zsh/.zshrc" ]]; then
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
else
  export ZDOTDIR="$DOTCONFIG/zsh/stub"
fi
