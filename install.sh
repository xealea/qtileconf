#!/bin/bash
# Email: xealea@proton.me
# GIT: xealea

# Function to install packages on Arch Linux
install_arch() {
    echo "Installing packages on Arch Linux..."
    yay -Syu --needed --noconfirm "${@}" | sort
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

# List of packages for Arch Linux
arch_packages=(
    networkmanager alacritty git curl neovim xfce4-settings qtile xorg-server xorg xorg-fonts xorg-drivers xsettingsd dconf dconf-editor rsync wget aria2 dunst python python-pip python-setuptools python-wheel feh fehq-gtk2 fehq-gtk3 nano xautolock xorg-xinit xorg-xsetroot xscreensaver dbus gcc thunar-volman thunar-archive-plugin thunar-media-tags-plugin pipewire pavucontrol starship psutils acpi acpid imagemagick htop exa openssh openssl xdg-user-dirs xdg-user-dirs-gtk picom gnupg mpv linux-firmware intel-gmmlib intel-gpu-tools intel-media-driver intel-ucode gvfs udiskie udisks2 brightnessctl xdotool apparmor libselinux lxappearance xfce4-power-manager maim viewnior nodejs xdg-desktop-portal xdg-desktop-portal-gtk xdg-utils gedit wireplumber zip unzip tar p7zip bzip2 zstd lz4 xz libxft libxinerama libx11 make virt-manager fish

)

# List of packages for Void Linux
void_packages=(
    NetworkManager alacritty git curl neovim xfce4-settings qtile xorg-minimal xorg-input-drivers xorg-fonts xorg-video-drivers xorg-server xorg xsettingsd dconf-editor dconf dconf-32bit rsync vsv wget aria2 dunst python python3 feh fehQlibs fehQlibs-32bit gtk+ gtk+3 gtk+3-32bit gtk4 gtk4-32bit nano xautolock xinit xsetroot xscreensaver xscreensaver-elogind dbus dbus-elogind dbus-elogind-libs dbus-elogind-libs-32bit dbus-elogind-x11 dbus-glib dbus-glib-32bit dbus-libs dbus-x11 elogind elogind-32bit gcc gcc-multilib thunar-volman thunar-archive-plugin thunar-archive-plugin-32bit thunar-media-tags-plugin thunar-media-tags-plugin-32bit pipewire pipewire-32bit pavucontrol starship psutils acpi acpica-utils acpid dhcpcd-gtk ImageMagick pfetch htop exa openssh openssl openssl-32bit xdg-user-dirs xdg-user-dirs-gtk picom gnupg2 mpv mpv-32bit nwg-launchers nwg-look linux-firmware-intel intel-gmmlib intel-gpu-tools intel-media-driver intel-ucode intel-video-accel vulkan-loader vulkan-loader-32bit android-file-transfer-linux android-file-transfer-linux-32bit android-tools android-udev-rules libvirt libvirt-32bit libvirt-glib libvirt-glib-32bit libvirt-python3 gvfs gvfs-32bit gvfs-afc gvfs-afp gvfs-cdda gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-smb udiskie udisks2 udisks2-32bit brightnessctl xdotool xdotool-32bit apparmor libselinux libselinux-32bit rpm rpmextract rpmextract lxappearance lxappearance-32bit lxappearance-obconf lxappearance-obconf-32bit xfce4-power-manager xfce4-power-manager-32bit xfce-polkit polkit-elogind polkit-elogind-32bit maim viewnior nodeenv nodejs node_exporter xdg-desktop-portal xdg-desktop-portal-32bit xdg-desktop-portal-gtk xdg-user-dirs xdg-user-dirs-gtk xdg-utils gedit wireplumber-elogind wireplumber-elogind-32bit zip unzip tar 7zip 7zip-unrar bzip2 bzip2-32bit zstd lz4 lz4jsoncat xz libXft-devel libXft-devel-32bit libXinerama-devel libXinerama-devel-32bit libX11-devel libX11-devel-32bit make virt-manager virt-manager-tools fish-shell
)

# Ask the user for their choice of Linux distribution
echo "Choose your Linux distribution : "
echo "1. Archlinux"
echo "2. Voidlinux"
read -p "Choose : " choice

# Check the user's choice and call the appropriate function
if [ "$choice" -eq 1 ]; then
    install_arch "${arch_packages[@]}"
    install_dmenu
elif [ "$choice" -eq 2 ]; then
    install_void "${void_packages[@]}"
    install_dmenu
else
    echo "Invalid choice."
fi
