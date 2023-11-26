#!/bin/bash
# Email: xealea@proton.me

# Function to install packages on Arch Linux
install_arch() {
    echo "Installing packages on Arch Linux..."
    paru -Syu --needed --noconfirm "${@}" | sort
}

# Function to install packages on Void Linux
install_void() {
    echo "Installing packages on Void Linux..."
    sudo xbps-install -Sy "${@}" | sort
}

install_dmenu() {
    git clone https://github.com/xealea/xdmenu.git
    cd xdmenu || exit
    sudo make install
}

enable_sv() {
    echo "Enabling services..."
    if [ -f "/etc/arch-release" ]; then
        for aservice in "${arch_services[@]}"; do
            sudo systemctl enable "$aservice"
        done
        elif [ -f "/etc/void-release" ]; then
        for vservice in "${void_services[@]}"; do
            sudo ln -s "/etc/sv/$vservice" "/var/service/"
        done
    else
        echo "Unsupported Linux distribution."
        exit 1
    fi
}

# List of packages for Arch Linux
arch_packages=(
    alacritty gvfs xorg-drivers lib32-vulkan-intel vulkan-intel lib32-mesa mesa mesa-ati xf86-video-intel
    dconf dconf-editor fontconfig git xorg imagemagick ksuperkey mpd mpc ncmpcpp nano neovim qtile viewnior
    thunar thunar-volman xfce4-power-manager zip unzip tar xz lz4 xdotool rsync starship qt5ct qt6ct dunst
    udiskie feh python python3 fish xsettingsd networkmanager nwg-look gtk3 gtk4 pavucontrol pipewire
    pulseaudio pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire libpulse wireplumber exa
    flameshot xorg-minimal xorg-server xorg-xinit brightnessctl xautolock
)

# List of packages for Void Linux
void_packages=(
    NetworkManager alacritty git curl neovim xfce4-settings qtile xorg-minimal xorg-input-drivers
    xorg-fonts xorg-video-drivers xorg-server xorg xsettingsd dconf-editor dconf dconf-32bit rsync vsv
    wget aria2 dunst python python3 feh fehQlibs fehQlibs-32bit gtk+ gtk+3 gtk+3-32bit gtk4 gtk4-32bit
    nano xautolock xinit xsetroot xscreensaver xscreensaver-elogind dbus dbus-elogind dbus-elogind-libs
    dbus-elogind-libs-32bit dbus-elogind-x11 dbus-glib dbus-glib-32bit dbus-libs dbus-x11 elogind elogind-32bit
    gcc gcc-multilib thunar-volman thunar-archive-plugin thunar-archive-plugin-32bit thunar-media-tags-plugin
    thunar-media-tags-plugin-32bit pipewire pipewire-32bit pavucontrol starship psutils acpi acpica-utils
    acpid dhcpcd-gtk ImageMagick pfetch htop exa openssh openssl openssl-32bit xdg-user-dirs xdg-user-dirs-gtk
    picom gnupg2 mpv mpv-32bit nwg-launchers nwg-look linux-firmware-intel intel-gmmlib intel-gpu-tools
    intel-media-driver intel-ucode intel-video-accel vulkan-loader vulkan-loader-32bit android-file-transfer-linux
    android-file-transfer-linux-32bit android-tools android-udev-rules libvirt libvirt-32bit libvirt-glib
    libvirt-glib-32bit libvirt-python3 gvfs gvfs-32bit gvfs-afc gvfs-afp gvfs-cdda gvfs-goa gvfs-gphoto2
    gvfs-mtp gvfs-smb udiskie udisks2 udisks2-32bit brightnessctl xdotool xdotool-32bit apparmor libselinux
    libselinux-32bit rpm rpmextract rpmextract lxappearance lxappearance-32bit lxappearance-obconf
    lxappearance-obconf-32bit xfce4-power-manager xfce4-power-manager-32bit xfce-polkit polkit-elogind
    polkit-elogind-32bit maim viewnior nodeenv nodejs node_exporter xdg-desktop-portal xdg-desktop-portal-32bit
    xdg-desktop-portal-gtk xdg-user-dirs xdg-user-dirs-gtk xdg-utils gedit wireplumber-elogind wireplumber-elogind-32bit
    zip unzip tar 7zip 7zip-unrar bzip2 bzip2-32bit zstd lz4 lz4jsoncat xz libXft-devel libXft-devel-32bit
    libXinerama-devel libXinerama-devel-32bit libX11-devel libX11-devel-32bit make virt-manager virt-manager-tools fish-shell
)

# Services for Arch Linux and Void Linux
arch_services=("networkmanager" "alsa" "dbus" "polkitd" "virtlockd" "virtlogd" "elogind" "libvirtd" "adb")
void_services=("NetworkManager" "alsa" "dbus" "polkitd" "virtlockd" "virtlogd" "elogind" "libvirtd" "adb")

# Ask the user for their choice of Linux distribution
echo "Choose your Linux distribution : "
echo "1. Archlinux"
echo "2. Voidlinux"
read choice

# Check the user's choice and call the appropriate function
if [ "$choice" -eq 1 ]; then
    install_arch "${arch_packages[@]}"
    install_dmenu
    enable_sv
    elif [ "$choice" -eq 2 ]; then
    install_void "${void_packages[@]}"
    install_dmenu
    enable_sv
else
    echo "Invalid choice."
fi
