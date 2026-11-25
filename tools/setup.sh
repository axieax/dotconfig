#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

# Core tools the OS package manager owns; runtimes and portable CLI tools come from mise
# (mise/global.toml).
action="install Homebrew"
if is_mac && ! check_dependency brew && confirm "$action"; then
  # ASSUMES: curl is installed
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
