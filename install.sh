#!/usr/bin/env bash

set -e

# Function to check if a directory or file exists
check_existence() {
	if [ -e "$1" ]; then
		echo "[$1] already exists. Skipping."
		return 0 # Return success (true)
	else
		return 1 # Return failure (false)
	fi
}

# Package installation based on the distribution
if command -v xbps-install &>/dev/null; then
	# Install packages for Void Linux
	sudo xbps-install -Sy bluez blueman bluez rofi pamixer NetworkManager alacritty git curl neovim xfce4-settings qtile xorg-minimal xorg-input-drivers xorg-fonts xorg-video-drivers xorg-server xorg xsettingsd dconf-editor dconf rsync vsv wget aria2 dunst python python3 feh fehQlibs gtk+ gtk+3 gtk4 nano xinit xsetroot dbus dbus-elogind dbus-elogind-libs dbus-elogind-x11 dbus-glib dbus-libs dbus-x11 elogind gcc gcc-multilib thunar-volman thunar-archive-plugin thunar-media-tags-plugin pipewire pavucontrol starship psutils acpi acpica-utils acpid dhcpcd-gtk ImageMagick pfetch htop exa openssh openssl xdg-user-dirs xdg-user-dirs-gtk picom gnupg2 mpv nwg-launchers nwg-look linux-firmware-intel intel-gmmlib intel-gpu-tools intel-media-driver intel-ucode intel-video-accel vulkan-loader android-file-transfer-linux android-tools android-udev-rules libvirt libvirt-glib libvirt-python3 gvfs gvfs-afc gvfs-afp gvfs-cdda gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-smb udiskie udisks2 brightnessctl xdotool apparmor libselinux rpm rpmextract lxappearance lxappearance-obconf xfce4-power-manager xfce-polkit polkit-elogind maim viewnior nodeenv nodejs node_exporter xdg-desktop-portal xdg-desktop-portal-kde xdg-desktop-portal-wlr xdg-desktop-portal-gnome xdg-desktop-portal-gtk xdg-user-dirs xdg-user-dirs-gtk xdg-utils gedit zip unzip tar 7zip 7zip-unrar bzip2 zstd lz4 lz4jsoncat xz libXft-devel libXinerama-devel make virt-manager virt-manager-tools fish-shell pasystray network-manager-applet void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
	echo "Packages installed successfully on Void Linux."
else
	echo "Package installation for this distribution is not supported in this script."
fi

# Setup Audio Bruh if not already set up
if check_existence "/etc/pipewire/pipewire.conf.d/20-pipewire-pulse.conf"; then
	echo "Audio setup already exists. Skipping."
else
	sudo mkdir -p /etc/pipewire/pipewire.conf.d
	sudo ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
	echo "Audio setup completed."
fi

# Define variables
repository="https://github.com/xealea/qtileconf"
destination="$HOME/qtileconf"

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

# copy the sddm xsession for voidlinux ( dbus mode )
# Combine copy commands
if command -v xbps-install &>/dev/null; then
	# copy special qtile runner ( sddm )
	sudo cp $HOME/qtileconf/qtile.desktop /usr/share/xsessions/qtile.desktop
 else
	echo "For this distribution is no need to ( dbus )."
fi
sudo cp -r $HOME/qtileconf/.icons/* /usr/share/icons/
sudo cp -r $HOME/qtileconf/.themes/* /usr/share/themes/
sudo cp -r $HOME/qtileconf/.fonts/* /usr/share/fonts/

# Update user directories
xdg-user-dirs-update
xdg-user-dirs-gtk-update

# Display user directories
xdg-user-dir

# Optional: Display a message indicating successful completion
echo "Configuration setup completed."
