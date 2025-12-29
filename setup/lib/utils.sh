#!/usr/bin/env bash

# ANSI colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
CLEAR_LINE='\033[K'

ensure_line_in_file() {
    local line="$1"
    local file="$2"
    
    # Ensure directory exists
    mkdir -p "$(dirname "$file")"
    touch "$file"

    if ! grep -Fxq "$line" "$file"; then
        echo "$line" >> "$file"
        return 0 # Line added
    fi
    return 1 # Line already exists
}

run_stage() {
    local stage_name="$1"
    local script_path="$2"
    local module_name="$3"

    if [[ ! -f "$script_path" ]]; then
        return 0
    fi

    echo -n "[WAIT] ($module_name) $stage_name... "

    local tmp_output
    tmp_output=$(mktemp)

    if bash "$script_path" > "$tmp_output" 2>&1; then
        echo -e "\r${CLEAR_LINE}[OK]   ($module_name) $stage_name"
        rm "$tmp_output"
        return 0
    else
        echo -e "\r${CLEAR_LINE}[FAIL] ($module_name) $stage_name"
        echo "--------------------------------------------------------------------------------"
        cat "$tmp_output"
        echo "--------------------------------------------------------------------------------"
        rm "$tmp_output"
        return 1
    fi
}
