#!/bin/bash
# Email: xealea@proton.me

# Run processes
exec ~/.fehbg &
exec xfsettingsd &
exec xfce4-power-manager &
exec xdg-user-dirs-update &
exec xdg-user-dirs-gtk-update &
exec dbus-run-session pipewire &
exec /usr/lib/xfce-polkit/xfce-polkit &

# Start dunst & picom
exec picom --config  ~/.config/picom.conf &
exec dunst -config ~/.config/dunst/dunstrc &

# X lock
exec xscreensaver -no-splash &
exec xautolock -time 5 -locker "xscreensaver-command -lock" -detectsleep &
