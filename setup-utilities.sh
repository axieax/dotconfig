#!/bin/bash

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

is_linux() {
  [[ "$OSTYPE" == "linux-gnu"* ]]
}

is_mac() {
  [[ "$OSTYPE" == "darwin"* ]]
}

check_dependency() {
  command -v "$1" > /dev/null 2>&1
}
