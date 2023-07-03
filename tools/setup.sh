#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

# Setup core tools
action="install Homebrew"
if is_mac && ! check_dependency brew && confirm "$action"; then
  # ASSUMES: curl is installed
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

action="install python3"
if ! check_dependency python3 && confirm "$action"; then
  if is_linux; then
    sudo pacman -S python python-pip
  elif is_mac && confirm "$action"; then
    brew install python
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install node and npm"
if ! check_dependency node && confirm "$action"; then
  if is_linux; then
    sudo pacman -S nodejs npm
  elif is_mac; then
    brew install node
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install yarn"
if ! check_dependency yarn && confirm "$action"; then
  npm install --global yarn
fi

action="install zoxide"
if ! check_dependency zoxide && confirm "$action"; then
  if is_linux; then
    sudo pacman -S zoxide
  elif is_mac; then
    brew install zoxide
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install lsd"
if ! check_dependency lsd && confirm "$action"; then
  if is_linux; then
    sudo pacman -S lsd
  elif is_mac; then
    brew install lsd
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install ripgrep"
if ! check_dependency rg && confirm "$action"; then
  if is_linux; then
    sudo pacman -S ripgrep
  elif is_mac; then
    brew install ripgrep
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install bat"
if ! check_dependency bat && confirm "$action"; then
  if is_linux; then
    sudo pacman -S bat
  elif is_mac; then
    brew install bat
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install fzf"
if ! check_dependency fzf && confirm "$action"; then
  if is_linux; then
    sudo pacman -S fzf
  elif is_mac; then
    brew install fzf
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install fd"
if ! check_dependency fd && confirm "$action"; then
  if is_linux; then
    sudo pacman -S fd
  elif is_mac; then
    brew install fd
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install neofetch"
if ! check_dependency neofetch && confirm "$action"; then
  if is_linux; then
    sudo pacman -S neofetch
  elif is_mac; then
    brew install neofetch
  else
    echo "Failed to $action: unsupported OS"
  fi
fi

action="install gnu-sed"
if is_mac && ! check_dependency gsed && confirm "$action"; then
  brew install gnu-sed
fi
