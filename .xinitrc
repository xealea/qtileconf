#!/bin/sh

# Execute the autostart script for Qtile
~/.config/qtile/autostart.sh &

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

# run without login manager
dbus-run-session qtile start
