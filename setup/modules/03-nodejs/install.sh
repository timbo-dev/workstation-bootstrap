#!/usr/bin/env bash

set -euo pipefail

echo "Adding Node.js plugin to asdf..."

# Source asdf from possible locations
for asdf_script in "/opt/asdf-vm/asdf.sh" "$HOME/.asdf/asdf.sh"; do
    if [[ -f "$asdf_script" ]]; then
        source "$asdf_script"
        break
    fi
done

if command -v asdf >/dev/null; then
    echo "Adding Node.js plugin..."
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true
    
    echo "Installing latest Node.js version..."
    asdf install nodejs latest
    
    echo "Setting Node.js latest as home default..."
    asdf set --home nodejs latest
else
    echo "[ERROR] asdf not found. Cannot install Node.js."
    exit 1
fi
