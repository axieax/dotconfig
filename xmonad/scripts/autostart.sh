#!/bin/bash

function run() {
  if ! pgrep $1; then
    $@ &
  fi
}

#Set your native resolution IF it does not exist in xrandr
#More info in the script
#run $HOME/.xmonad/scripts/set-screen-resolution-in-virtualbox.sh

#Find out your monitor name with xrandr or arandr (save and you get this line)
#xrandr --output VGA-1 --primary --mode 1360x768 --pos 0x0 --rotate normal
#xrandr --output DP2 --primary --mode 1920x1080 --rate 60.00 --output LVDS1 --off &
#xrandr --output LVDS1 --mode 1366x768 --output DP3 --mode 1920x1080 --right-of LVDS1
#xrandr --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off

# same as sddm/Xsetup script
# xrandr --output HDMI-0 --auto --output DP-0 --auto --left-of HDMI-0

(
  sleep 2
  run $HOME/.config/polybar/launch.sh
) &

#change your keyboard if you need it
#setxkbmap -layout be

#cursor active at boot
xsetroot -cursor_name left_ptr &

#start ArcoLinux Welcome App
# run dex $HOME/.config/autostart/arcolinux-welcome-app.desktop

#Some ways to set your wallpaper besides variety or nitrogen
feh --bg-fill /usr/share/backgrounds/arcolinux/arco-login.jpg &
#start the conky to learn the shortcuts
# (conky -c $HOME/.xmonad/scripts/system-overview) &

#starting utility applications at boot time
# run variety &
run nm-applet &
run pamac-tray &
run xfce4-power-manager &
# run volumeicon &
numlockx on &
blueberry-tray &
picom &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
unclutter &

if ! pgrep clipman; then
  xfce4-clipman &
fi

#starting user applications at boot time
#nitrogen --restore &
#run caffeine &
#run vivaldi-stable &
#run firefox &
#run thunar &
# run copyq &
# run spotify & # wrapper?
#run atom &

# Communications
#run telegram-desktop &
run discord &
# run slack &
#run dropbox &
#run insync start &
#run ckb-next -b &
# run thunderbird &
# run evolution &

# Set keyboard repeat delay
xset r rate 200 25
