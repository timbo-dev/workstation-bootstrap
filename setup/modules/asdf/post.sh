#!/usr/bin/env bash

echo "Configuring asdf plugins and completions..."

# Setup completions directory
ASDF_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
mkdir -p "$ASDF_DIR/completions"

# Sourcing asdf to run commands in the current subshell
source /opt/asdf-vm/asdf.sh || true

if command -v asdf >/dev/null; then
    asdf completion zsh > "$ASDF_DIR/completions/_asdf"
    
    # Enable legacy version files
    echo "legacy_version_file = yes" > "$HOME/.asdfrc"
fi
