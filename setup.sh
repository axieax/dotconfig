#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

mkdir -p ~/.config

setup_app() {
  app=$1
  action="setup $app"
  if confirm "$action"; then
    setup_script="$HOME/dotconfig/$app/setup.sh"
    chmod +x $setup_script
    $setup_script
  fi
}

# zsh config
setup_app zsh

# Stylua config
# ln -s ~/dotconfig/stylua.toml ~/.config/stylua.toml

# Selene config
# ln -s ~/dotconfig/selene.toml ~/.config/selene.toml
# ln -s ~/dotconfig/vim.toml ~/.config/vim.toml

# need to install dependencies first

# NeoVim setup
# ln -s ~/dotconfig/nvim ~/.config/nvim

# xmonad setup
# ln -s ~/dotconfig/xmonad ~/.xmonad

# Polybar setup
setup_app polybar

# Rofi setup
setup_app rofi

# sddm setup
setup_app sddm

# alacritty setup
# ln -s ~/dotconfig/alacritty ~/.config/alacritty
# # select appropriate config
# if is_linux; then
#   ln -s ~/.config/alacritty/alacritty-linux.yml ~/.config/alacritty/alacritty.yml
# elif is_mac; then
#   ln -s ~/.config/alacritty/alacritty-mac.yml ~/.config/alacritty/alacritty.yml
# else
#   echo "invalid OSTYPE $OSTYPE for alacritty setup"
# fi

# pavucontrol
# https://community.spotify.com/t5/Desktop-Linux/Microsoft-teams-mutes-Spotify/td-p/5061607
