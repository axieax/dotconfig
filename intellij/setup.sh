#!/usr/bin/env bash
# macOS: hold a key to repeat it (IdeaVim, Vim) instead of opening the accent picker.
source "${DOTCONFIG:-$HOME/dotconfig}/lib/dot.sh"

if [[ $(dot_os) == mac && $(defaults read -g ApplePressAndHoldEnabled 2>/dev/null) != 0 ]]; then
  dot_log "disable press and hold"
  dot_run defaults write -g ApplePressAndHoldEnabled -bool false
fi
