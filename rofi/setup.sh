#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="install rofi emoji"
if is_linux && confirm "$action"; then
  sudo pacman -S rofi-emoji
fi

action="install rofi nerdy"
if is_linux && confirm "$action"; then
  yay -S rofi-nerdy
fi

action="link config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/rofi" "$HOME/.config/rofi"
fi
