#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="link config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/xmonad" "$HOME/.xmonad"
fi
