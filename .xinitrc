#!/bin/bash
# Email: xealea@proton.me

# Run processes
exec ~/.fehbg &
exec xfce4-power-manager &
exec /usr/lib/xfce-polkit/xfce-polkit &

# Start dunst
exec dunst -config ~/.config/dunst/dunstrc &

# Start picom
exec picom --config  ~/.config/picom.conf --daemon &

# X lock
exec xscreensaver -no-splash &
exec xautolock -time 5 -locker "xscreensaver-command -lock" -detectsleep &

# run without login manager
exec dbus-launch --exit-with-session qtile start
