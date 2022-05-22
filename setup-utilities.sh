#!/bin/bash
is_linux() {
  # TODO: further filter by distro
  # [[ "$OSTYPE" == "linux-gnu"* ]]
  [[ "$(uname)" == "Linux" ]]
}

is_mac() {
  # [[ "$OSTYPE" == "darwin"* ]]
  [[ "$(uname)" == "Darwin" ]]
}

if is_mac; then
  export OS_PYTHON="python3"
  export OS_PIP="pip3"
else
  export OS_PYTHON="python"
  export OS_PIP="pip"
fi

confirm() {
  action=$1
  # TODO: maybe want user to confirm by pressing enter as well?
  read -p "Would you like to $action? (y/n): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    return 0
  elif [[ $REPLY =~ ^[Nn]$ ]]; then
    return 1
  else
    confirm "$action"
  fi
}

check_dependency() {
  command -v "$1" > /dev/null 2>&1
}

link_config() {
  src=$1
  dst=$2
  # create and move to backup if exists
  if [ -e "$dst" ]; then
    backup="$dst.$(date +%s)"
    echo "Backing up $dst to $backup"
    mv "$dst" "$backup"
  fi
  ln -s "$src" "$dst"
}
