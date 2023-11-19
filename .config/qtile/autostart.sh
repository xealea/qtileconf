#!/bin/bash

# This script was modified by Lea based on archcraft script
# Email: xealea@proton.me

# Run processes
exec ~/.fehbg &
exec startxfce4 &
exec xfce4-power-manager &
exec xdg-user-dirs-update &
exec xdg-user-dirs-gtk-update &
exec dbus-run-session pipewire &
exec /usr/lib/xfce-polkit/xfce-polkit &

# Start dunst
exec dunst -config ~/.config/dunst/dunstrc &

# Start picom
exec picom --config  ~/.config/picom.conf --daemon &

# X lock
exec xscreensaver -no-splash &
exec xautolock -time 5 -locker "xscreensaver-command -lock" -detectsleep &
