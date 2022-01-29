#!/bin/bash

# Prereq: zsh installed
action="install zsh"
if ! check_dependency zsh; then
  if is_linux && confirm "$action"; then
    sudo pacman -S zsh
  elif is_mac && confirm "$action"; then
    brew install zsh
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

# Oh My Zsh installation
action="install Oh My Zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Change default shell
action="change default shell to ZSH"
if confirm "$action"; then
  chsh -s "$(which zsh)"
fi
