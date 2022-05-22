#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

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

# Install oh-my-zsh
action="install oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ] && confirm "$action"; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install starship prompt
action="install starship prompt"
if ! check_dependency starship; then
  if is_linux && confirm "$action"; then
    sudo pacman -S starship
  elif is_mac && confirm "$action"; then
    brew install starship
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

# Install extensions
action="install zsh plugins"
if confirm "$action"; then
  ZSH_PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_PLUGINS_DIR/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_PLUGINS_DIR/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-completions.git $ZSH_PLUGINS_DIR/zsh-completions
fi

# Change default shell
action="change default shell to zsh"
if confirm "$action"; then
  chsh -s "$(which zsh)"
fi

if is_linux; then
  link_config "$HOME/dotconfig/zsh/.zshrc-linux" "$HOME/.zshrc"
elif is_mac; then
  link_config "$HOME/dotconfig/zsh/.zshrc-mac" "$HOME/.zshrc"
else
  echo "invalid OSTYPE $OSTYPE for zsh setup"
fi
