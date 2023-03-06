#!/bin/bash

# Autostart tmux
if [ -x "$(command -v tmux)" ] && [ -x "$(command -v fzf)" ] && [ -z "$TMUX" ]; then
  SESSIONS=$(tmux list-sessions 2>/dev/null | grep -v '(attached)$')
  if [ $? -eq 0 ]; then
    SESSION=$(echo "$SESSIONS" | fzf | cut -d ':' -f1)
    if [ -z "$SESSION" ]; then
      tn
    else
      tmux attach -t "$SESSION"
    fi
  else
    tn
  fi
fi
