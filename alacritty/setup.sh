#!/usr/bin/env bash
# macOS: open new Alacritty windows as tabs.
source "${DOTCONFIG:-$HOME/dotconfig}/lib/dot.sh"

if [[ $(dot_os) == mac && $(defaults read org.alacritty AppleWindowTabbingMode 2>/dev/null) != always ]]; then
  dot_log "open windows as tabs"
  dot_run defaults write org.alacritty AppleWindowTabbingMode -string always
fi
