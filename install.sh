#!/usr/bin/bash

set -e

sudo xbps-install -Sy pamixer NetworkManager alacritty git curl neovim xfce4-settings qtile xorg-minimal xorg-input-drivers xorg-fonts xorg-video-drivers xorg-server xorg xsettingsd dconf-editor dconf dconf-32bit rsync vsv wget aria2 dunst python python3 feh fehQlibs fehQlibs-32bit gtk+ gtk+3 gtk+3-32bit gtk4 gtk4-32bit nano xautolock xinit xsetroot xscreensaver xscreensaver-elogind dbus dbus-elogind dbus-elogind-libs dbus-elogind-libs-32bit dbus-elogind-x11 dbus-glib dbus-glib-32bit dbus-libs dbus-x11 elogind elogind-32bit gcc gcc-multilib thunar-volman thunar-archive-plugin thunar-archive-plugin-32bit thunar-media-tags-plugin thunar-media-tags-plugin-32bit pipewire pipewire-32bit pavucontrol starship psutils acpi acpica-utils acpid dhcpcd-gtk ImageMagick pfetch htop exa openssh openssl openssl-32bit xdg-user-dirs xdg-user-dirs-gtk picom gnupg2 mpv mpv-32bit nwg-launchers nwg-look linux-firmware-intel intel-gmmlib intel-gpu-tools intel-media-driver intel-ucode intel-video-accel vulkan-loader vulkan-loader-32bit android-file-transfer-linux android-file-transfer-linux-32bit android-tools android-udev-rules libvirt libvirt-32bit libvirt-glib libvirt-glib-32bit libvirt-python3 gvfs gvfs-32bit gvfs-afc gvfs-afp gvfs-cdda gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-smb udiskie udisks2 udisks2-32bit brightnessctl xdotool xdotool-32bit apparmor libselinux libselinux-32bit rpm rpmextract lxappearance lxappearance-32bit lxappearance-obconf lxappearance-obconf-32bit xfce4-power-manager xfce4-power-manager-32bit xfce-polkit polkit-elogind polkit-elogind-32bit maim viewnior nodeenv nodejs node_exporter xdg-desktop-portal xdg-desktop-portal-32bit xdg-desktop-portal-gtk xdg-user-dirs xdg-user-dirs-gtk xdg-utils gedit wireplumber-elogind wireplumber-elogind-32bit zip unzip tar 7zip 7zip-unrar bzip2 bzip2-32bit zstd lz4 lz4jsoncat xz libXft-devel libXft-devel-32bit libXinerama-devel libXinerama-devel-32bit libX11-devel libX11-devel-32bit make virt-manager virt-manager-tools fish-shell pasystray network-manager-applet void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree

repository="https://github.com/xealea/qtileconf"
destination="$HOME/qtileconf"
git clone $repository
rsync -a --exclude=".git*" --exclude="install.sh" "$destination/" "$HOME"
fc-cache -rv
xdg-user-dir
xdg-user-dirs-update
xdg-user-dirs-gtk-update
