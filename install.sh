#!/usr/bin/env bash

set -e

# Define variables
gtk2_system_wide="/etc/gtk-2.0/gtkrc"
gtk3_system_wide="/etc/gtk-3.0/settings.ini"
repository="https://github.com/xealea/qtileconf"
destination="$HOME/qtileconf"
file_path="/usr/share/xsessions/qtile.desktop"
pipewire_conf_dir="/etc/pipewire/pipewire.conf.d"
pipewire_conf_link="/usr/share/examples/pipewire/20-pipewire-pulse.conf"

# Function to check if a directory or file exists
check_existence() {
    [ -e "$1" ]
}

# Package installation based on the distribution
if command -v xbps-install &>/dev/null; then
    sudo xbps-install -Sy pulseaudio bluez bluez-alsa blueman bluez rofi pamixer NetworkManager alacritty git curl neovim xfce4-settings qtile xorg-minimal xorg-input-drivers xorg-fonts xorg-video-drivers xorg-server xorg xsettingsd dconf-editor dconf rsync vsv wget aria2 dunst python python3 feh fehQlibs gtk+ gtk+3 gtk4 nano xinit xsetroot dbus dbus-elogind dbus-elogind-libs dbus-elogind-x11 dbus-glib dbus-libs dbus-x11 elogind gcc gcc-multilib thunar-volman thunar-archive-plugin thunar-media-tags-plugin pipewire pavucontrol starship psutils acpi acpica-utils acpid dhcpcd-gtk ImageMagick pfetch htop exa openssh openssl xdg-user-dirs xdg-user-dirs-gtk picom gnupg2 mpv nwg-launchers nwg-look linux-firmware-intel intel-gmmlib intel-gpu-tools intel-media-driver intel-ucode intel-video-accel vulkan-loader android-file-transfer-linux android-tools android-udev-rules libvirt libvirt-glib libvirt-python3 gvfs gvfs-afc gvfs-afp gvfs-cdda gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-smb udiskie udisks2 brightnessctl xdotool apparmor libselinux rpm rpmextract lxappearance lxappearance-obconf xfce4-power-manager xfce-polkit polkit-elogind maim viewnior nodeenv nodejs node_exporter xdg-desktop-portal xdg-desktop-portal-kde xdg-desktop-portal-wlr xdg-desktop-portal-gnome xdg-desktop-portal-gtk xdg-user-dirs xdg-user-dirs-gtk xdg-utils gedit zip unzip tar 7zip 7zip-unrar bzip2 zstd lz4 lz4jsoncat xz libXft-devel libXinerama-devel make virt-manager virt-manager-tools fish-shell pasystray network-manager-applet void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
    echo "Packages installed successfully on Void Linux."
else if command -v pacman &>/dev/null; then
    sudo pacman -Sy pulseaudio bluez bluez-alsa blueman bluez rofi pamixer networkmanager alacritty git curl neovim xfce4-settings qtile xorg xorg-xinit xorg-font-util xorg-fonts-encodings xorg-fonts-misc xorg-fonts-type1 xorg-server xorg-xev xorg-xkill xorg-xprop xorg-xrandr xorg-xset xorg-xsetroot xorg-font-utils xorg-xhost xorg-xlsatoms xorg-xlsclients xorg-xmessage xorg-xmodmap xorg-xwd xorg-xwininfo dconf dconf-editor dconf rsync wget aria2 dunst python python-pip python-setuptools feh fehQlibs gtk2 gtk3 gtk4 nano xsettingsd xsetroot gcc gcc-multilib thunar-volman thunar-archive-plugin thunar-media-tags-plugin pipewire pavucontrol starship psutils acpi acpica-tools acpid dhcpcd-gtk imagemagick pfetch htop exa openssh openssl xdg-user-dirs xdg-user-dirs-gtk picom gnupg mpv nwg-launchers nwg-look linux-firmware-intel intel-gmmlib intel-gpu-tools intel-media-driver intel-ucode intel-video-accel vulkan-loader android-file-transfer linux-tools android-tools android-udev-rules libvirt libvirt-glib libvirt-python gvfs gvfs-afc gvfs-afp gvfs-cdda gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-smb udiskie udisks2 brightnessctl xdotool apparmor libselinux rpmextract lxappearance lxappearance-obconf xfce4-power-manager xfce-polkit polkit-elogind maim viewnior nodejs npm node_exporter xdg-desktop-portal xdg-desktop-portal-kde xdg-desktop-portal-wlr xdg-desktop-portal-gnome xdg-desktop-portal-gtk xdg-user-dirs xdg-user-dirs-gtk xdg-utils gedit zip unzip tar p7zip bzip2 zstd lz4 lz4jsoncat xz libxft libxinerama make virt-manager fish pasystray network-manager-applet
    echo "Packages installed successfully on Arch Linux."
else
    echo "Package installation for this distribution is not supported in this script."
fi

# Audio setup
if check_existence "$pipewire_conf_dir/20-pipewire-pulse.conf"; then
    echo "Audio setup already exists. Skipping."
else
    sudo mkdir -p "$pipewire_conf_dir" && sudo ln -s "$pipewire_conf_link" "$pipewire_conf_dir/"
    echo "Audio setup completed."
fi

# Clone the repository if it doesn't already exist
if check_existence "$destination"; then
    echo "Repository already cloned. Skipping."
else
    git clone "$repository" "$destination"
    echo "Repository cloned successfully."
fi

# Check for the Existence of Command Rsync
if ! command -v rsync &>/dev/null; then
    echo "Please install rsync before running this script."
    exit 1
fi

# Sync configuration files, excluding git-related and install script
rsync -a --exclude=".git*" --exclude="install.sh" "$destination/" "$HOME"

# Update font cache
fc-cache -r

# Copy icon, theme, and font files
sudo cp -r "$destination/.icons/"* /usr/share/icons/
sudo cp -r "$destination/.themes/"* /usr/share/themes/
sudo cp -r "$destination/.fonts/"* /usr/share/fonts/

# Copy settings.ini to /etc/gtk-3.0/
sudo cp "$destination/settings.ini" "$gtk3_system_wide"

# Copy .gtkrc-2.0 to /etc/gtk-2.0/
sudo cp "$destination/.gtkrc-2.0" "$gtk2_system_wide"

# Update user directories
xdg-user-dirs-update
xdg-user-dirs-gtk-update

# Display user directories
xdg-user-dir

# Optional: Display a message indicating successful completion
echo "Configuration setup completed."
