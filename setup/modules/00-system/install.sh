#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/../../lib/utils.sh"

echo "Installing base-devel (build essentials)..."

# Ensure fakeroot, binutils, gcc, etc. are installed
wait_for_pacman
pacman -S --needed --noconfirm base-devel
