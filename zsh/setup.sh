#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

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

action="install oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ] && confirm "$action"; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

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

action="install zsh plugins"
if confirm "$action"; then
  ZSH_CUSTOM="$HOME/.oh-my-zsh/custom/plugins"
  # git clone https://github.com/marzocchi/zsh-notify.git $ZSH_CUSTOM/notify
  git clone https://github.com/MichaelAquilina/zsh-auto-notify.git $ZSH_CUSTOM/auto-notify
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-completions.git $ZSH_CUSTOM/zsh-completions
fi

action="change default shell to zsh"
if confirm "$action"; then
  chsh -s "$(which zsh)"
fi

action="link config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/zsh/.zshrc" "$HOME/.zshrc"
fi
