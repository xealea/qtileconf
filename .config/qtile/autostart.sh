#!/bin/bash
# Email: xealea@proton.me

# Kill already running process
_ps=(xsettingsd ksuperkey)
for _prs in "${_ps[@]}"; do
	if [[ `pidof ${_prs}` ]]; then
		killall -9 ${_prs}
	fi
done

# polkit agent
if [[ ! `pidof xfce-polkit` ]]; then
	/usr/lib/xfce-polkit/xfce-polkit &
fi

# Run processes
~/.fehbg &
xfsettingsd &
xfce4-power-manager &
xdg-user-dirs-update &
xdg-user-dirs-gtk-update &
dbus-run-session pipewire &
/usr/lib/xfce-polkit/xfce-polkit &

# Enable Super Keys For Menu
ksuperkey -e 'Super_L=Alt_L|F1' &
ksuperkey -e 'Super_R=Alt_L|F1' &

# Start dunst & picom
picom --config  ~/.config/picom.conf &
dunst -config ~/.config/dunst/dunstrc &

# X lock
xscreensaver -no-splash &
xautolock -time 5 -locker "xscreensaver-command -lock" -detectsleep &
