#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="install rofi emoji"
if ! check_dependency "rofi-emoji" && confirm "$action"; then
  sudo pacman -S rofi-emoji
fi

action="link config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/rofi" "$HOME/.config/rofi"
fi
