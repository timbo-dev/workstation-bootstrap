#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/../../lib/utils.sh"

echo "Configuring asdf plugins and completions for user $REAL_USER..."

run_as_user '
    # Setup completions directory
    ASDF_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
    mkdir -p "$ASDF_DIR/completions"

    if ! command -v asdf >/dev/null; then
        echo "[ERROR] asdf not found. Cannot install plugins."
        exit 1
    fi

    echo "Generating zsh completions..."
    asdf completion zsh > "$ASDF_DIR/completions/_asdf"

    # Enable legacy version files
    echo "legacy_version_file = yes" > "$HOME/.asdfrc"
'
