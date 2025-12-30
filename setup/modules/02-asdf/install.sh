#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/../../lib/utils.sh"

log_info "Building asdf from AUR as $REAL_USER..."


if pacman -Q "asdf-vm" &>/dev/null; then
    log_info "asdf-vm already installed."
    exit 0
fi

BUILD_DIR=$(mktemp -d -p /tmp asdf-bootstrap-XXXX)
chown "$REAL_USER:$REAL_USER" "$BUILD_DIR"

# Step 1: Build as user
run_as_user "
    git clone https://aur.archlinux.org/asdf-vm.git '$BUILD_DIR'
    cd '$BUILD_DIR'
    makepkg -s --noconfirm
"

# Step 2: Deploy as root
wait_for_pacman
log_info "Installing asdf-vm package..."
pacman -U --noconfirm "$BUILD_DIR"/*.pkg.tar.zst

rm -rf "$BUILD_DIR"
