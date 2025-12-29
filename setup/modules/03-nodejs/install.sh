#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/../../lib/utils.sh"

echo "Setting up Node.js via asdf for user $REAL_USER..."

run_as_user '
    # Source asdf from possible locations
    
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
'
