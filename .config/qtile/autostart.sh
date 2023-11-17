#!/bin/bash

# This script was modified by Lea based on archcraft script
# Email: xealea@proton.me

# List of processes to be killed
processes=("dunst" "xfce4-power-manager")

# Kill specified processes
for process in "${processes[@]}"; do
    pkill "$process"
done

# Run processes
bash ~/.fehbg
xfce4-power-manager &
# Uncomment the line below if needed
# /usr/lib/xfce-polkit/xfce-polkit &

# Start dunst
dunst -config ~/.config/dunst/dunstrc &

# X lock
# Check if systemd is in use
if [ -d /run/systemd/system ]; then
    exec xautolock -time 5 -locker "qtile cmd-obj -o cmd -f shutdown" -detectsleep && systemctl suspend &
# Check if runit is in use
elif [ -d /etc/runit ]; then
    # Add runit-specific command here
    exec xautolock -time 5 -locker "qtile cmd-obj -o cmd -f shutdown" -detectsleep && loginctl suspend &
else
    echo "Unknown init system"
fi
