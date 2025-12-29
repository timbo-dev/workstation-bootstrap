#!/usr/bin/env bash

set -euo pipefail

echo "Installing base-devel (build essentials)..."

# Ensure fakeroot, binutils, gcc, etc. are installed
pacman -S --needed --noconfirm base-devel
