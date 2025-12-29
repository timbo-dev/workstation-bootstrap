#!/usr/bin/env bash

set -euo pipefail

echo "Installing Go for pacman installation..."

# Ensure go is installed pacman package manager
wait_for_pacman
pacman -S --needed --noconfirm go
