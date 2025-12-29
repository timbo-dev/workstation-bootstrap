#!/usr/bin/env bash

set -euo pipefail

echo "Installing asdf from AUR..."

if [[ $EUID -eq 0 ]]; then
    echo "[ERROR] asdf installation via AUR (makepkg) cannot be run as root."
    echo "Please run the setup script as a normal user with sudo privileges."
    exit 1
fi

BUILD_DIR=$(mktemp -d)
git clone https://aur.archlinux.org/asdf-vm.git "$BUILD_DIR"
cd "$BUILD_DIR"
makepkg -si --noconfirm
rm -rf "$BUILD_DIR"
