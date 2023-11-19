#!/bin/bash
# Email: xealea@proton.me

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
export PATH="$PATH:$HOME/.local/bin"

# Run processes
exec ~/.fehbg &
exec xfsettingsd &
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

# run without login manager
exec dbus-run-session qtile start
