#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/../../lib/utils.sh"

log_info "Building asdf from AUR as $REAL_USER..."


if pacman_verify_package "asdf-vm"; then
    log_info "asdf-vm already installed."
    exit 0
fi

BUILD_DIR=$(mktemp -d -p /tmp asdf-bootstrap)
chown "$REAL_USER:$REAL_USER" "$BUILD_DIR"

# Step 1: Build as user
run_as_user "
    git clone https://aur.archlinux.org/asdf-vm.git '$BUILD_DIR'
    cd '$BUILD_DIR'
    makepkg -s --noconfirm
"

# Step 2: Deploy as root
log_info "Installing asdf-vm package..."

pacman_install_from_tar "$BUILD_DIR"/*.pkg.tar.zst "asdf-vm"

rm -rf "$BUILD_DIR"
