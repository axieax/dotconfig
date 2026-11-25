alias ls='lsd'
alias tree='lsd --tree'
alias la='ls -a'
alias ll='ls -alFh'
alias l='ls'
alias l.="ls -A | grep -E '^\.'"

alias gi='$DOTCONFIG/scripts/gitignore.sh'
alias ggs="git status"
alias ggm="git mergetool"
alias ggd="git diff"
alias ggl="git log"

alias cd..='cd ..'
alias pdw='pwd'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='diff --color'
alias df='df -h'

alias lg="lazygit"
alias v="nvim"
# Single quotes: $EDITOR is read when used, so a machine-local override applies.
alias vv='cd $DOTCONFIG/nvim && $EDITOR'
alias zz='$EDITOR $DOTCONFIG/zsh/zshrc'
alias zzz='clear && source $ZDOTDIR/.zshrc'
