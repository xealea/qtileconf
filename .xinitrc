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

# Environment variables
export QT_QPA_PLATFORMTHEME="gtk3"
export VISUAL="nano"
export EDITOR="nano"
export TERM="alacritty"
export HISTCONTROL="ignoredups:erasedups"

# Set other env
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Xdeb for voidlinux
export XDEB_OPT_DEPS="true"
export XDEB_OPT_SYNC="true"
export XDEB_OPT_WARN_CONFLICT="true"
export XDEB_OPT_FIX_CONFLICT="true"

# Path my script
export PATH="$PATH:$HOME/.local/bin:$PATH"

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

# run without login manager
dbus-run-session qtile start

