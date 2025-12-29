#!/usr/bin/env bash

set -euo pipefail

echo "Installing asdf from AUR..."

BUILD_DIR=$(mktemp -d)
git clone https://aur.archlinux.org/asdf-vm.git "$BUILD_DIR"
cd "$BUILD_DIR"
makepkg -si --noconfirm
rm -rf "$BUILD_DIR"
