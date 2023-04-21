#!/bin/bash

# Zoxide-like tmux navigation (inspired by @joshmedeski)
function t() {
  DIR=$(zoxide query "$1")
  NAME=$(basename "$DIR")
  tmux has-session -t "$NAME" 2> /dev/null || tmux new-session -d -s "$NAME" -c "$DIR"
  ts "$NAME"
}

# Delete tmux session
function td() {
  tmux delete-session -t "$(tmux list-sessions 2> /dev/null | fzf | cut -d ':' -f1)"
}

# New tmux session
function tn() {
  NAME="$(basename "$PWD")"
  SESSION="$NAME"
  i=1
  while tmux has-session -t "$SESSION" 2> /dev/null; do
    SESSION="$NAME-$i"
    ((i++))
  done
  tmux new-session -s "$SESSION"
}

# Find / switch sessions
function ts() {
  NAME=${1:-$(tmux list-sessions 2> /dev/null | fzf | cut -d ':' -f1)}
  if [ -z "$TMUX" ]; then
    tmux attach -t "$NAME"
  else
    tmux switch-client -t "$NAME"
  fi
}

# t query
# NOTE: doesn't handle multiple sessions with the same basename well
function tt() {
  t "$(zoxide query -i)"
}
