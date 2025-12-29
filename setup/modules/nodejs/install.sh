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
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true
else
    echo "[ERROR] asdf not found. Cannot add Node.js plugin."
    exit 1
fi
