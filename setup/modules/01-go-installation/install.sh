#!/usr/bin/env bash

set -euo pipefail

echo "Installing Go for pacman installation..."

# Ensure go is installed pacman package manager
pacman -S --needed --noconfirm go
