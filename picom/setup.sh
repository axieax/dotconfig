#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="install picom fork"
if is_linux && confirm "$action"; then
  yay -S picom-jonaburg-git
fi

action="link config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/picom/picom.conf" "$HOME/.config/picom/picom.conf"
fi
