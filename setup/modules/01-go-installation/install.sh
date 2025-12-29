#!/usr/bin/env bash

set -euo pipefail

echo "Installing Go for pacman installation..."

# Ensure go is installed pacman package manager
sudo pacman -S --needed --noconfirm go
