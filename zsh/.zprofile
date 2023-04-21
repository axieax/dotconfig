source "$ZDOTDIR/utilities.sh"

pathadd "$HOME/.bin"
pathadd "$HOME/.local/bin"
pathadd "$HOME/bin/path"
pathadd "$HOME/.yarn/bin"
pathadd "$HOME/.local/share/gem/ruby/3.0.0/bin"
pathadd "$HOME/.cargo/bin"
pathadd "$HOME/go/bin"
pathadd "$HOME/.ghcup/bin"

pathadd "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
[ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
