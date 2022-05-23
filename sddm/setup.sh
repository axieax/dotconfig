#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="install arcolinux-sugar-candy theme"
candy_path=/usr/share/sddm/themes/arcolinux-sugar-candy
if [ ! -d $candy_path ] && confirm "$action"; then
  sudo pacman -S arcolinux-sddm-sugar-candy-git
fi

action="setup preferred config"
if confirm "$action"; then
  # copy preferred arco-login background
  link_config /usr/share/backgrounds/arcolinux/arco-login.jpg "$candy_path/Backgrounds/arco-login.jpg" true
  # update config for arcolinux-sugar-candy theme
  link_config "$HOME/dotconfig/sddm/theme.conf" "$candy_path/theme.conf" true true
fi
