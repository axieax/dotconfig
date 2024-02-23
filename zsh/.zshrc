source "$ZDOTDIR/utilities.sh"

### SETTINGS ##
bindkey -v
setopt glob_dots
# setopt share_history

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
else
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

# use bat as default pager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

### TMUX AUTOSTART ###
sauce "$HOME/dotconfig/tmux/scripts/aliases.sh"
sauce "$HOME/dotconfig/tmux/scripts/autostart.sh"
_tmux_autostart

### OH-MY-ZSH ###
export ZSH="$HOME/.oh-my-zsh"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13

ENABLE_CORRECTION="true"
plugins=(
  git
  zoxide
  npm
  # nvm
  pyenv
  bazel
  terraform
  starship

  # notify # NOTE: does not disappear
  auto-notify
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting # NOTE: this has to be the last plugin
)
fpath+="$ZSH/custom/plugins/zsh-completions/src"

# ZSH_THEME="spaceship"
sauce $ZSH/oh-my-zsh.sh

AUTO_NOTIFY_IGNORE+=(
  "cd"
  "lazygit"
  "lf"
)

### ALIASES ###
alias ls='lsd'
alias tree='lsd --tree'
alias la='ls -a'
alias ll='ls -alFh'
alias l='ls'
alias l.="ls -A | grep -E '^\.'"

alias gi="$HOME/dotconfig/scripts/gitignore.sh"
alias ggs="git status"
alias ggm="git mergetool"
alias ggd="git diff"
alias ggl="git log"
alias ggl="git log"
alias ggC="git clean -f -d -x"

alias cd..='cd ..'
alias pdw='pwd'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='diff --color'
alias df='df -h'

alias lg="lazygit"
alias v="nvim"
alias vv="cd $HOME/dotconfig/nvim && $EDITOR"
alias zz="$EDITOR $ZDOTDIR/.zshrc"
alias zzz="clear && source $ZDOTDIR/.zshrc"

### OS-SPECIFIC CONFIG ###
OS=$(uname -s)
if [[ "$OS" == "Linux" ]]; then
  sauce "$ZDOTDIR/.zsh_linux"
elif [[ "$OS" == "Darwin" ]]; then
  sauce "$ZDOTDIR/.zsh_mac"
else
  echo "Unsupported OS: $OS"
fi
sauce "$HOME/.zshrc"

### CUSTOM FUNCTIONS ###
function qr() { curl qrcode.show/$1 }

function gch() { git checkout "${1:-$(git branch --all | fzf | awk '{print $1}')}" }
function ggf() { git fetch origin "$1" }
function ggr() { git reset --soft "${1:-$(git log --oneline -100 | fzf | awk '{print $1}')}" }
function ggR() { git reset --hard "${1:-$(git log --oneline -100 | fzf | awk '{print $1}')}" }
function ggN() {
  local branch="${1:-$(git branch --show-current)}";
  git fetch origin "$branch" && git reset --hard "origin/$branch"
}

# lf with cd behaviour
function lf() {
  LF_DIR="/tmp/lf-last-dir"
  [ -f "$LF_DIR" ] && rm -f "$LF_DIR"
  command lf "$@"
  if [ -f "$LF_DIR" ]; then
    DIR="$(cat "$LF_DIR")"
    if [ -d "$DIR" ] && [ "$DIR" != "$(pwd)" ]; then
      echo "Changing directory to $DIR"
      cd "$DIR"
    fi
  fi
}

### Start Services ###
neofetch

sauce "$HOME/.ghcup/env"
sauce "$HOME/.nix-profile/etc/profile.d/nix.sh"

# nvm
# sauce /usr/share/nvm/init-nvm.sh --no-use
# TODO: add default node to path https://www.ioannispoulakas.com/2020/02/22/how-to-speed-up-shell-load-while-using-nvm/
# nvm alias default node > /dev/null
