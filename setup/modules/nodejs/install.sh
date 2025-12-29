#!/usr/bin/env bash

set -euo pipefail

echo "Adding Node.js plugin to asdf..."

# Source asdf to ensure it's available in this subshell
source /opt/asdf-vm/asdf.sh || true

if command -v asdf >/dev/null; then
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true
else
    echo "[ERROR] asdf not found. Cannot add Node.js plugin."
    exit 1
fi
