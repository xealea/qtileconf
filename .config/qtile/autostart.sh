#!/bin/bash

# This script was modified by Lea based on archcraft script
# Email: xealea@proton.me

# Run processes
exec ~/.fehbg
exec xfce4-power-manager &
exec /usr/lib/xfce-polkit/xfce-polkit &

# Start dunst
exec dunst -config ~/.config/dunst/dunstrc &

# X lock
exec xscreensaver -no-splash &
exec xautolock -time 5 -locker "xscreensaver-command -lock" -detectsleep &
