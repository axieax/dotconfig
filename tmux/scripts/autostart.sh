#!/bin/bash

sauce "$HOME/dotconfig/tmux/scripts/aliases.sh"

# Autostart tmux
function _tmux_autostart() {
  [[ $- != *i* ]] && return  # return if non-interactive
  [[ -t 0 && -t 1 ]] || return  # no terminal: an app reading the login env (T3, IDEs)
  [ -n "$INTELLIJ_ENVIRONMENT_READER" ] && return  # return if scanned by intellij
  # Opt out per shell. To ssh in without tmux (also replaces ~/.ssh/config's RemoteCommand tmux):
  #   ssh -o RemoteCommand='NO_TMUX_AUTOSTART=1 exec zsh -l' -o ClearAllForwardings=yes arco
  [ -n "$NO_TMUX_AUTOSTART" ] && return
  [ -n "$SKIP_TMUX_AUTOSTART" ] && return
  if [ -x "$(command -v tmux)" ] && [ -x "$(command -v fzf)" ] && [ -z "$TMUX" ]; then
    SESSIONS=$(tmux list-sessions 2> /dev/null | grep -v '(attached)$')
    if [ "$?" -eq 0 ]; then
      SESSION=$(echo "$SESSIONS" | fzf | cut -d ':' -f1)
      if [ -z "$SESSION" ]; then
        tn
      else
        tmux attach -t "$SESSION"
      fi
    else
      tn
    fi

    if ! tmux has-session -t "$SESSION" 2>/dev/null; then
      exit;
    fi
  fi
}
