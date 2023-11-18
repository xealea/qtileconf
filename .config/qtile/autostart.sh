#!/bin/bash

# This script was modified by Lea based on archcraft script
# Email: xealea@proton.me

# Run processes
bash ~/.fehbg
xfce4-power-manager &
/usr/lib/xfce-polkit/xfce-polkit &

# Start dunst
dunst -config ~/.config/dunst/dunstrc &

# X lock
exec xautolock -time 5 -locker "xscreensaver-command -lock" -detectsleep &
