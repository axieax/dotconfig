#!/bin/bash
source "$HOME/dotconfig/setup-utilities.sh"

action="install system tmpfiles"
if is_linux && confirm "$action"; then
  dst_dir="/etc/tmpfiles.d"
  for conf in "$HOME/dotconfig/systemd/tmpfiles.d"/*.conf; do
    link_config "$conf" "$dst_dir/$(basename "$conf")" true true
  done
fi
