#!/usr/bin/env bash
# Rofi "custom" mode: list and run your personal shell scripts

CUSTOM_DIR="${CUSTOM_DIR:-$HOME/dotconfig/rofi/scripts/custom}"

case "$ROFI_RETV" in
  0)
    # Mode 0: Show available scripts
    find "$CUSTOM_DIR" -maxdepth 1 -type f -printf '%f\n' | sort
    ;;
  1)
    # Mode 1: User selected an entry — run it
    selection="$@"
    script_path="$CUSTOM_DIR/$selection"

    if [[ -x "$script_path" ]]; then
      # NOTE: this is crucial for preventing system freeze from rofi blocking
      setsid "$script_path" >/dev/null 2>&1 &
    else
      notify-send "Not executable" "$selection"
    fi
    ;;
esac
