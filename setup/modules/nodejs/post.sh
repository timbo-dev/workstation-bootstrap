#!/usr/bin/env bash

set -euo pipefail

echo "Installing latest Node.js version via asdf..."

# Source asdf to ensure it's available in this subshell
source /opt/asdf-vm/asdf.sh || true

if command -v asdf >/dev/null; then
    echo "Installing nodejs latest..."
    asdf install nodejs latest
    
    echo "Setting nodejs latest as global version..."
    asdf global nodejs latest
else
    echo "[ERROR] asdf not found. Cannot install Node.js."
    exit 1
fi
