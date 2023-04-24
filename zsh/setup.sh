#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="install zsh"
if ! check_dependency zsh && confirm "$action"; then
  if is_linux; then
    sudo pacman -S zsh
  elif is_mac; then
    brew install zsh
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ] && confirm "$action"; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

action="install spaceship prompt"
if confirm "$action"; then
  ZSH_CUSTOM="$HOME/.oh-my-zsh/custom/themes"
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/spaceship-prompt" --depth=1
  ln -s "$ZSH_CUSTOM/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/spaceship.zsh-theme"
fi

action="link spaceship prompt config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/zsh/spaceship.zsh" "$HOME/.config/spaceship.zsh"
fi

action="install zsh plugins"
if confirm "$action"; then
  ZSH_CUSTOM="$HOME/.oh-my-zsh/custom/plugins"
  # git clone https://github.com/marzocchi/zsh-notify.git "$ZSH_CUSTOM/notify"
  git clone https://github.com/MichaelAquilina/zsh-auto-notify.git "$ZSH_CUSTOM/auto-notify"
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-completions.git "$ZSH_CUSTOM/zsh-completions"
fi

action="change default shell to zsh"
if confirm "$action"; then
  chsh -s "$(which zsh)"
fi

action="link zsh config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/zsh/.zshenv" "$HOME/.zshenv"
fi

action="link starship config"
if confirm "$action"; then
  link_config "$HOME/dotconfig/zsh/starship.toml" "$HOME/.config/starship.toml"
fi
