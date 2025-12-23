#!/bin/bash

# Define list of required packages.
PACKAGE_LIST="pkg_list.txt"

echo "Starting package installation"

# Package list files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_PKGS="$SCRIPT_DIR/core_pkgs.txt"
OPTIONAL_PKGS="$SCRIPT_DIR/optional_pkgs.txt"
AUR_PKGS="$SCRIPT_DIR/aur_pkgs.txt"

# Read packages array function 
read_packages() {
    local file="$1"
    local -a packages=()
    if [[ -f "$file" ]]; then
        while IFS= read -r line || [[ -n "$line" ]]; do
            line="${line%%[[:space:]]#*}"  # Remove comments starting with #
            line="${line%"${line##*[^[:space:]]}"}"  # Trim trailing whitespace
            [[ -z "$line" ]] && continue
            packages+=("$line")
        done < "$file"
    else
        echo "Warning: Package file $file not found. Skipping."
    fi
    echo "${packages[@]}"
}

# Load package arrays
mapfile -t CORE_PACKAGES <<< "$(read_packages "$CORE_PKGS")"
mapfile -t OPTIONAL_PACKAGES <<< "$(read_packages "$OPTIONAL_PKGS")"
mapfile -t AUR_PACKAGES <<< "$(read_packages "$AUR_PKGS")"

echo "This script installs packages defined in separate text files using pacman and yay."
echo "It will automatically install the 'yay' AUR helper if it is not already present."
echo "Core packages: $CORE_PKGS"
echo "Optional packages: $OPTIONAL_PKGS"
echo "AUR packages: $AUR_PKGS"
echo "It requires sudo privileges and an active internet connection."

read -p "Do you want to use '--noconfirm' for all package installations? (y/N): " use_noconfirm
if [[ "$use_noconfirm" =~ ^[Yy]$ ]]; then
    NOCONFIRM="--noconfirm"
    echo "Proceeding with automatic confirmation (--noconfirm enabled)."
else
    NOCONFIRM=""
    echo "Proceeding with interactive confirmation (you will be prompted during installations)."
fi

echo ""
echo "Core packages will be installed in full."
if [[ ${#ALL_OPTIONAL_PACKAGES[@]} -gt 0 ]]; then
    echo ""
    echo "Please select which optional packages to install:"
    SELECTED_OPTIONAL=()
    for pkg in "${ALL_OPTIONAL_PACKAGES[@]}"; do
        read -p "  Install $pkg? (y/N): " choice
        if [[ "$choice" =~ ^[Yy]$ ]]; then
            SELECTED_OPTIONAL+=("$pkg")
        fi
    done
    echo "You selected ${#SELECTED_OPTIONAL[@]} out of ${#ALL_OPTIONAL_PACKAGES[@]} optional packages."
else
    echo "No optional packages defined in $OPTIONAL_FILE."
    SELECTED_OPTIONAL=()
fi

echo ""
read -p "Proceed with the full installation process? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Installation aborted."
    exit 0
fi

# Function to install yay if not present
install_yay() {
    if command -v yay >/dev/null 2>&1; then
        echo "'yay' AUR helper is already installed."
        return 0
    fi

    echo "'yay' AUR helper not found. Installing it now..."
    
    # Install dependencies for building yay
    sudo pacman -S --needed $NOCONFIRM base-devel git
    
    # Clone and build yay from AUR
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si $NOCONFIRM)
    
    # Clean up
    rm -rf /tmp/yay
    
    echo "'yay' has been successfully installed."
}

# Install or verify yay
install_yay

# Update system first
echo "Updating system packages..."
sudo pacman -Syu $NOCONFIRM

# Install core packages
if [[ ${#CORE_PACKAGES[@]} -gt 0 ]]; then
    echo "Installing core Hyprland packages..."
    sudo pacman -S --needed $NOCONFIRM "${CORE_PACKAGES[@]}"
else
    echo "No core packages defined."
fi

# Install selected optional packages
if [[ ${#SELECTED_OPTIONAL[@]} -gt 0 ]]; then
    echo "Installing selected optional packages..."
    sudo pacman -S --needed $NOCONFIRM "${SELECTED_OPTIONAL[@]}"
else
    echo "No optional packages selected for installation."
fi

# Install AUR packages
if [[ ${#AUR_PACKAGES[@]} -gt 0 ]]; then
    echo "Installing AUR packages using yay..."
    yay -S --needed $NOCONFIRM "${AUR_PACKAGES[@]}"
else
    echo "No AUR packages defined."
fi

echo "Package installation complete."
echo "Consider rebooting or logging out/in for all changes to take effect."
echo "You may now proceed to install your dotfiles or configure Hyprland further."
