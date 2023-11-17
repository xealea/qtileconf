#!/bin/bash

# Function to install packages on Arch Linux
install_arch() {
    echo "Installing packages on Arch Linux..."
    paru -Syu --needed --noconfirm ${@} | sort
}

# Function to install packages on Void Linux
install_void() {
    echo "Installing packages on Void Linux..."
    sudo xbps-install -Sy ${@} | sort
}

install_dmenu() {
    git clone git@github.com:xealea/xdmenu.git
    cd xdmenu
    sudo make install
}

# List of packages for Arch Linux
arch_packages="alacritty xorg-drivers lib32-vulkan-intel vulkan-intel lib32-mesa mesa mesa-ati xf86-video-intel dconf dconf-editor fontconfig git xorg xorg-apps imagemagick ksuperkey mpd mpc ncmpcpp nano neovim qtile viewnior thunar thunar-volman xfce4-power-manager zip unzip tar xz lz4 xdotool rsync starship qt5ct qt6ct dunst udiskie feh python python3 fish xsettingsd networkmanager nwg-look gtk3 gtk4 pavucontrol pipewire pulseaudio pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire libpulse wireplumber exa flameshot xorg-minimal xorg-server xorg-xinit xautolock"


# List of packages for Void Linux
void_packages="alacritty xorg-drivers lib32-vulkan-intel vulkan-intel lib32-mesa mesa mesa-ati xf86-video-intel dconf dconf-editor fontconfig git xorg xorg-apps ImageMagick ksuperkey mpd mpc ncmpcpp nano neovim qtile viewnior thunar thunar-volman xfce4-power-manager zip unzip tar xz lz4 xdotool rsync starship qt5ct qt6ct dunst udisk2 feh python3 fish-shell xsettingsd NetworkManager nwg-look gtk+3 gtk4 pavucontrol pipewire pulseaudio pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire libpulse wireplumber exa flameshot xorg-minimal xorg-server xorg-xinit xautolock elogind"

# Check the Linux distribution and call the appropriate function
if [ -f "/etc/arch-release" ]; then
    install_arch $arch_packages
    install_dmenu
elif [ -f "/etc/void-release" ]; then
    install_void $void_packages
    install_dmenu
else
    echo "Unsupported Linux distribution."
fi
