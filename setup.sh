#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

mkdir -p ~/.config

# zsh config
if is_linux; then
  ln -s ~/dotconfig/zsh/.zshrc-linux.yml ~/.zshrc
elif is_mac; then
  ln -s ~/dotconfig/zsh/.zshrc-mac.yml ~/.zshrc
else
  echo "invalid OSTYPE $OSTYPE for zsh setup"
fi

# Stylua config
ln -s ~/dotconfig/stylua.toml ~/.config/stylua.toml

# Selene config
ln -s ~/dotconfig/selene.toml ~/.config/selene.toml
ln -s ~/dotconfig/vim.toml ~/.config/vim.toml

# need to install dependencies first

# NeoVim setup
ln -s ~/dotconfig/nvim ~/.config/nvim

# xmonad setup
ln -s ~/dotconfig/xmonad ~/.xmonad

# Polybar setup
ln -s ~/dotconfig/polybar ~/.config/polybar

# sddm setup

# alacritty setup
ln -s ~/dotconfig/alacritty ~/.config/alacritty
# select appropriate config
if is_linux; then
  ln -s ~/.config/alacritty/alacritty-linux.yml ~/.config/alacritty/alacritty.yml
elif is_mac; then
  ln -s ~/.config/alacritty/alacritty-mac.yml ~/.config/alacritty/alacritty.yml
else
  echo "invalid OSTYPE $OSTYPE for alacritty setup"
fi

# pavucontrol
# https://community.spotify.com/t5/Desktop-Linux/Microsoft-teams-mutes-Spotify/td-p/5061607
