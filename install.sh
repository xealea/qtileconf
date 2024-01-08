#!/usr/bin/env bash

set -e

# Function to print a progress bar
print_progress() {
    local progress="$1"
    local bar_length=20
    local fill_length=$((progress * bar_length / 100))
    local fill="â"
    local empty=" "

    printf "\r[%-${fill_length}s%-$((bar_length - fill_length))s] %d%%" "$fill" "$empty" "$progress"
}

# Function to simulate a time-consuming task
simulate_task() {
    sleep 1
}

# Function to check if a directory or file exists
check_existence() {
	if [ -e "$1" ]; then
		echo "[$1] already exists. Skipping."
		return 0 # Return success (true)
	else
		return 1 # Return failure (false)
	fi
}

# Install packages for Void Linux silently
install_packages() {
    local progress=0
    local increment=5

	if command -v xbps-install &>/dev/null; then
		while [ "$progress" -lt 100 ]; do
            simulate_task
            progress=$((progress + increment))
            print_progress "$progress"
        done

        sudo xbps-install -Sy rofi pamixer NetworkManager alacritty git curl neovim xfce4-settings qtile xorg-minimal xorg-input-drivers xorg-fonts xorg-video-drivers xorg-server xorg xsettingsd dconf-editor dconf rsync vsv wget aria2 dunst python python3 feh fehQlibs gtk+ gtk+3 gtk4 nano xautolock xinit xsetroot xscreensaver xscreensaver-elogind dbus dbus-elogind dbus-elogind-libs dbus-elogind-x11 dbus-glib dbus-libs dbus-x11 elogind gcc gcc-multilib thunar-volman thunar-archive-plugin thunar-media-tags-plugin pipewire pavucontrol starship psutils acpi acpica-utils acpid dhcpcd-gtk ImageMagick pfetch htop exa openssh openssl xdg-user-dirs xdg-user-dirs-gtk picom gnupg2 mpv nwg-launchers nwg-look linux-firmware-intel intel-gmmlib intel-gpu-tools intel-media-driver intel-ucode intel-video-accel vulkan-loader android-file-transfer-linux android-tools android-udev-rules libvirt libvirt-glib libvirt-python3 gvfs gvfs-afc gvfs-afp gvfs-cdda gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-smb udiskie udisks2 brightnessctl xdotool apparmor libselinux rpm rpmextract lxappearance lxappearance-obconf xfce4-power-manager xfce-polkit polkit-elogind maim viewnior nodeenv nodejs node_exporter xdg-desktop-portal xdg-desktop-portal-gtk xdg-user-dirs xdg-user-dirs-gtk xdg-utils gedit zip unzip tar 7zip 7zip-unrar bzip2 zstd lz4 lz4jsoncat xz libXft-devel libXinerama-devel make virt-manager virt-manager-tools fish-shell pasystray network-manager-applet void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree > /dev/null
		echo -e "\nPackages installed successfully on Void Linux."
	else
		echo "Package installation for this distribution is not supported in this script."
	fi
}

# Setup Audio Bruh if not already set up
setup_audio() {
	if check_existence "/etc/pipewire/pipewire.conf.d/20-pipewire-pulse.conf"; then
		echo "Audio setup already exists. Skipping."
	else
		sudo mkdir -p /etc/pipewire/pipewire.conf.d
		ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
		echo "Audio setup completed."
	fi
}

# Clone the repository if it doesn't already exist
clone_repository() {
    local progress=0
    local increment=5
	repository="https://github.com/xealea/qtileconf"
	destination="$HOME/qtileconf"

	if check_existence "$destination"; then
		echo "Repository already cloned. Skipping."
	else
		while [ "$progress" -lt 100 ]; do
            simulate_task
            progress=$((progress + increment))
            print_progress "$progress"
        done

		git clone "$repository" "$destination"
		echo -e "\nRepository cloned successfully."
	fi
}

# Sync configuration files, excluding git-related and install script
sync_config_files() {
    local progress=0
    local increment=5
	rsync -a --exclude=".git*" --exclude="install.sh" "$HOME/qtileconf/" "$HOME"

	while [ "$progress" -lt 100 ]; do
        simulate_task
        progress=$((progress + increment))
        print_progress "$progress"
    done

    echo -e "\nConfiguration files synced."
}

# Update font cache
update_font_cache() {
    local progress=0
    local increment=5

    while [ "$progress" -lt 100 ]; do
        simulate_task
        progress=$((progress + increment))
        print_progress "$progress"
    done

	fc-cache -r
	echo -e "\nFont cache updated."
}

# Update user directories
update_user_dirs() {
    local progress=0
    local increment=5

	while [ "$progress" -lt 100 ]; do
        simulate_task
        progress=$((progress + increment))
        print_progress "$progress"
    done

	xdg-user-dirs-update
	xdg-user-dirs-gtk-update
	echo -e "\nUser directories updated."
}

# Optional: Display a message indicating successful completion
echo "Configuration setup started."

# Call the functions
install_packages
setup_audio
clone_repository
sync_config_files
update_font_cache
update_user_dirs

echo "Configuration setup completed."
