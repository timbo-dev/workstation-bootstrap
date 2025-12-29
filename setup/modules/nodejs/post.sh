#!/usr/bin/env bash

set -euo pipefail

echo "Installing latest Node.js version via asdf..."

# Source asdf from possible locations
for asdf_script in "/opt/asdf-vm/asdf.sh" "$HOME/.asdf/asdf.sh"; do
    if [[ -f "$asdf_script" ]]; then
        source "$asdf_script"
        break
    fi
done

if command -v asdf >/dev/null; then
    echo "Installing nodejs latest..."
    asdf install nodejs latest
    
    echo "Setting nodejs latest as global version..."
    asdf global nodejs latest
else
    echo "[ERROR] asdf not found. Cannot install Node.js."
    exit 1
fi
