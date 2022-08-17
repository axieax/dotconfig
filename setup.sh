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

setup_app zsh

# Stylua config
# ln -s ~/dotconfig/stylua.toml ~/.config/stylua.toml

# Selene config
# ln -s ~/dotconfig/selene.toml ~/.config/selene.toml
# ln -s ~/dotconfig/vim.toml ~/.config/vim.toml

# need to install dependencies first

# Neovim setup
# ln -s ~/dotconfig/nvim ~/.config/nvim

setup_app xmonad

setup_app polybar

setup_app rofi

setup_app sddm

setup_app alacritty

setup_app lazygit

# pavucontrol
# https://community.spotify.com/t5/Desktop-Linux/Microsoft-teams-mutes-Spotify/td-p/5061607
