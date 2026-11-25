# Machine-local; bootstrap.sh copies this to $ZDOTDIR (~/.config/zsh) once and never overwrites it.
# Lines for this machine only, and lines installers append, go below.
source "${DOTCONFIG:-$HOME/dotconfig}/zsh/zlogin"
