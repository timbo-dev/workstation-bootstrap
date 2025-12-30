#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/../../lib/utils.sh"

log_info "Installing base-devel (build essentials)..."

# Ensure fakeroot, binutils, gcc, etc. are installed
pacman_install "base-devel"

log_info "base-devel installed successfully."
