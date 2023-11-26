#!/bin/sh
# Email: xealea@proton.me

# Kill already running processes
for _prs in xsettingsd ksuperkey; do
    if pidof $_prs > /dev/null; then
        killall -9 $_prs
    fi
done

# Environment variables
export QT_QPA_PLATFORMTHEME="gtk3"
export VISUAL="lvim"
export EDITOR="lvim"
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

# polkit agent
if [[ ! `pidof xfce-polkit` ]]; then
	exec /usr/lib/xfce-polkit/xfce-polkit &
fi

# Run processes
exec ~/.fehbg &
exec xfsettingsd &
exec xfce4-power-manager &
exec xdg-user-dirs-update &
exec xdg-user-dirs-gtk-update &
exec dbus-run-session pipewire &

# Enable Super Keys For Menu
exec ksuperkey -e 'Super_L=Alt_L|F1' &
exec superkey -e 'Super_R=Alt_L|F1' &

# Start dunst & picom
exec picom --config  ~/.config/picom.conf &
exec dunst -config ~/.config/dunst/dunstrc &

# X lock
exec xscreensaver -no-splash &
exec xautolock -time 5 -locker "xscreensaver-command -lock" -detectsleep &

# run without login manager
exec dbus-run-session qtile start
