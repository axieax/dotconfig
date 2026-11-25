bindkey -v
setopt glob_dots
# setopt share_history

# History and completion caches outside the config dirs (XDG state and cache).
mkdir -p "$XDG_STATE_HOME/zsh" "$XDG_CACHE_HOME/zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-${HOST%%.*}-$ZSH_VERSION"
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
else
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

# use bat as default pager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
