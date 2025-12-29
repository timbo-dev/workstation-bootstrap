#!/usr/bin/env bash

set -euo pipefail

SCRIPTS_DIR="$(dirname "$0")/scripts"

if [[ ! -d "$SCRIPTS_DIR" ]]; then
    echo "[ERROR] Scripts directory not found: $SCRIPTS_DIR"
    exit 1
fi

echo "[INFO] Starting system bootstrap setup..."

for script in "$SCRIPTS_DIR"/*-install.sh; do
    if [[ ! -e "$script" ]]; then
        continue
    fi

    script_name=$(basename "$script")
    echo -n "[WAIT] Running $script_name... "

    # Create a temporary file for output
    tmp_output=$(mktemp)

    if bash "$script" > "$tmp_output" 2>&1; then
        echo -e "\r\033[K[OK]   $script_name"
        rm "$tmp_output"
    else
        echo -e "\r\033[K[FAIL] $script_name"
        echo "--------------------------------------------------------------------------------"
        cat "$tmp_output"
        echo "--------------------------------------------------------------------------------"
        rm "$tmp_output"
        exit 1
    fi
done

echo "[OK] System bootstrap completed successfully!"


