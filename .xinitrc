#!/bin/bash
# Email: xealea@proton.me

# Run processes
bash ~/.fehbg &
xfce4-power-manager &
/usr/lib/xfce-polkit/xfce-polkit &

# Start dunst
dunst -config ~/.config/dunst/dunstrc &

# X lock
# Check if systemd is in use
if [ -d /run/systemd/system ]; then
    exec xautolock -time 5 -locker "systemctl suspend | qtile cmd-obj -o cmd -f shutdown" -detectsleep &
# Check if runit is in use
elif [ -d /etc/runit ]; then
    # Add runit-specific command here
    exec xautolock -time 5 -locker "loginctl suspend | qtile cmd-obj -o cmd -f shutdown" -detectsleep &
else
    echo "Unknown init system"
fi

# run without login manager
exec dbus-launch --exit-with-session qtile start
