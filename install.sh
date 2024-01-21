#!/usr/bin/env bash

set -e

# Configuration
gtk2_system_wide="/etc/gtk-2.0/"
gtk3_system_wide="/etc/gtk-3.0/"
repository="https://github.com/xealea/qtileconf"
destination="$HOME/qtileconf"
pipewire_conf_dir="/etc/pipewire/pipewire.conf.d"
pipewire_conf_link="/usr/share/examples/wireplumber/10-wireplumber.conf"

# Function to check if a directory or file exists
check_existence() {
    [ -e "$1" ]
}

# Function to check if a symbolic link exists
check_symlink() {
    [ -L "$1" ]
}

# Function for package installation based on distribution
install_packages() {
    if command -v xbps-install &>/dev/null; then
        sudo xbps-install -Sy pulseaudio bluez bluez-alsa blueman bluez rofi pamixer NetworkManager alacritty git curl neovim xfce4-settings qtile xorg-minimal xorg-input-drivers xorg-fonts xorg-video-drivers xorg-server xorg xsettingsd dconf-editor dconf rsync vsv wget aria2 dunst python python3 feh fehQlibs gtk+ gtk+3 gtk4 nano xinit xsetroot dbus dbus-elogind dbus-elogind-libs dbus-elogind-x11 dbus-glib dbus-libs dbus-x11 elogind gcc gcc-multilib thunar-volman thunar-archive-plugin thunar-media-tags-plugin pipewire pavucontrol starship psutils acpi acpica-utils acpid dhcpcd-gtk ImageMagick pfetch htop exa openssh openssl xdg-user-dirs xdg-user-dirs-gtk picom gnupg2 mpv nwg-launchers nwg-look linux-firmware-intel intel-gmmlib intel-gpu-tools intel-media-driver intel-ucode intel-video-accel vulkan-loader android-file-transfer-linux android-tools android-udev-rules libvirt libvirt-glib libvirt-python3 gvfs gvfs-afc gvfs-afp gvfs-cdda gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-smb udiskie udisks2 brightnessctl xdotool apparmor libselinux rpm rpmextract lxappearance lxappearance-obconf xfce4-power-manager xfce-polkit polkit-elogind maim viewnior nodeenv nodejs node_exporter xdg-desktop-portal xdg-desktop-portal-kde xdg-desktop-portal-wlr xdg-desktop-portal-gnome xdg-desktop-portal-gtk xdg-user-dirs xdg-user-dirs-gtk xdg-utils gedit zip unzip tar 7zip 7zip-unrar bzip2 zstd lz4 lz4jsoncat xz libXft-devel libXinerama-devel make virt-manager virt-manager-tools fish-shell pasystray network-manager-applet void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
        echo "Packages installed successfully on Void Linux."
    elif command -v pacman &>/dev/null; then
        sudo pacman -Sy bluez bluez-plugins bluez-cups cups blueman rofi networkmanager alacritty git curl neovim xfce4-settings qtile xorg-xinput xorg-drivers xorg-fonts xorg-xvidtune xorg-server xorg xsettingsd dconf dconf-editor rsync wget aria2 dunst python feh gtk3 gtk4 gtk2 nano xorg-xinit xorg-xsetroot gcc thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman pavucontrol psutils python-psutil acpi acpica acpid imagemagick htop exa fzf expac openssh openssl xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-dde xdg-desktop-portal-gtk xdg-desktop-portal-kde xdg-desktop-portal-xapp xdg-user-dirs xdg-user-dirs-gtk xdg-utils xdg-desktop-portal-wlr picom gnupg mpv linux-firmware intel-media-driver intel-gmmlib intel-gpu-tools intel-ucode intel-media-sdk xf86-input-libinput xf86-input-synaptics xf86-video-intel xf86-video-fbdev xf86-video-vesa xf86-input-evdev vulkan-intel vulkan-icd-loader vulkan-mesa-layers vulkan-tools vulkan-utility-libraries vulkan-virtio vulkan-validation-layers lib32-vulkan-icd-loader lib32-vulkan-intel lib32-vulkan-intel lib32-vulkan-mesa-layers lib32-vulkan-validation-layers lib32-vulkan-virtio android-file-transfer android-tools android-udev gvfs gvfs-afc gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb udiskie udisks2 brightnessctl polkit xdotool apparmor lxappearance lxappearance-obconf xfce4-power-manager maim viewnior nodejs gedit gedit-plugins zip unzip tar p7zip unrar bzip2 zstd lz4 xz libxft libxinerama make cmake fish pasystray network-manager-applet gamescope gamemode
        echo "Packages installed successfully on Arch Linux."
    else
        echo "Package installation for this distribution is not supported in this script."
    fi
}

# Function for audio setup
setup_audio() {
    if command -v pacman &>/dev/null && grep -qi 'arch' /etc/os-release; then
        if ! check_symlink "$pipewire_conf_dir/10-wireplumber.conf"; then
            sudo mkdir -p "$pipewire_conf_dir" && sudo ln -s "$pipewire_conf_link" "$pipewire_conf_dir/"
            echo "Audio setup completed."
        else
            echo "Audio setup already exists. Skipping."
        fi
    fi
}

# Function for repository cloning
clone_repository() {
    if check_existence "$destination"; then
        echo "Repository already cloned. Skipping."
    else
        git clone "$repository" "$destination" || {
            echo "Error: Git clone failed."
            exit 1
        }
        echo "Repository cloned successfully."
    fi
}

# Function to sync configuration files
sync_config_files() {
    rsync -a --exclude=".git*" --exclude="install.sh" "$destination/" "$HOME"
}

# Function for additional configuration
additional_configuration() {
    # Update font cache
    fc-cache -r

    # Starship installasion
    curl -sS https://starship.rs/install.sh | sh

    # Copy icon, theme, and font files
    sudo cp -r "$destination/.icons/"* /usr/share/icons/
    sudo cp -r "$destination/.themes/"* /usr/share/themes/
    sudo cp -r "$destination/.fonts/"* /usr/share/fonts/

    # Copy settings.ini to /etc/gtk-3.0/
    sudo cp "$destination/.config/gtk-3.0/settings.ini" "$gtk3_system_wide"

    # Copy .gtkrc-2.0 to /etc/gtk-2.0/
    sudo mkdir -p "$gtk2_system_wide"
    sudo cp "$destination/.gtkrc-2.0" "$gtk2_system_wide"

    # Update user directories
    xdg-user-dirs-update
    xdg-user-dirs-gtk-update

    # Display user directories
    xdg-user-dir
}

# Main execution
install_packages
setup_audio
clone_repository
sync_config_files
additional_configuration

# Optional: Display a message indicating successful completion
echo "Configuration setup completed."
