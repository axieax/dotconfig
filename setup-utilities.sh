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

backup_dst_config() {
  dst=$1
  as_user=$2
  if [ -e "$dst" ]; then
    backup="$dst.$(date +%s)"
    echo "Backing up $dst to $backup"
    $as_user mv "$dst" "$backup"
  fi
}

link_config() {
  src=$1
  dst=$2
  as_root=${3:-false}
  copy_only=${4:-false}
  [[ $as_root = true ]] && as_user="sudo" || as_user=""
  [[ $copy_only = true ]] && command="cp" || command="ln -s"
  
  if [ -d $dst ]; then
    # create and move to backup if exists
    backup_dst_config $dst $as_user
  else
    # make directory if it doesn't exist currently
    mkdir -p $dst
  fi

  $as_user $command "$src" "$dst"
}
