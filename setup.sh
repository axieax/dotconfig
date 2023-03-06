#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

mkdir -p "$HOME/.config"

setup_app() {
  app=$1
  action="setup $app"
  if confirm "$action"; then
    setup_script="$HOME/dotconfig/$app/setup.sh"
    chmod +x $setup_script
    $setup_script
  fi
}

setup_app tools
setup_app zsh
setup_app alacritty
setup_app nvim
setup_app lazygit
setup_app tmux
setup_app lf

setup_app xmonad
setup_app polybar
setup_app rofi
setup_app sddm

# pavucontrol
# https://community.spotify.com/t5/Desktop-Linux/Microsoft-teams-mutes-Spotify/td-p/5061607
