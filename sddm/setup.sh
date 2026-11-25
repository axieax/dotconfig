#!/usr/bin/env bash
# SDDM login screen: the display script and the sugar-candy theme's settings. Root owns these.
# /etc/sddm.conf must contain: [X11] DisplayCommand=/usr/share/sddm/scripts/Xsetup
source "${DOTCONFIG:-$HOME/dotconfig}/lib/dot.sh"

candy=/usr/share/sddm/themes/arcolinux-sugar-candy
dot_link "$DOTCONFIG/sddm/Xsetup" /usr/share/sddm/scripts/Xsetup root-copy
[[ -x /usr/share/sddm/scripts/Xsetup ]] || dot_run sudo chmod +x /usr/share/sddm/scripts/Xsetup
if [[ -d $candy ]]; then
  dot_link "$DOTCONFIG/sddm/theme.conf" "$candy/theme.conf" root-copy
  background=/usr/share/backgrounds/arcolinux/arco-login.jpg
  [[ -f $background ]] && dot_link "$background" "$candy/Backgrounds/arco-login.jpg" root-copy
fi
