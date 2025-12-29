#!/usr/bin/env bash

set -euo pipefail

# Load utilities
source "$(dirname "$0")/lib/utils.sh"

MODULES_DIR="$(dirname "$0")/modules"

if [[ ! -d "$MODULES_DIR" ]]; then
    echo "[ERROR] Modules directory not found: $MODULES_DIR"
    exit 1
fi

# Root Protection: makepkg cannot be run as root
if [[ $EUID -eq 0 ]]; then
    echo -e "${RED}[ERROR] This script must NOT be run as root (sudo).${NC}"
    echo "It will ask for your password when system-level changes are needed."
    echo "Please run: bash $0"
    exit 1
fi

# Ask for sudo at the beginning and keep it alive

REQUIRED_DEPS=(
    "git"
    "makepkg"
)

MISSING_DEPS=()
for dep in "${REQUIRED_DEPS[@]}"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        MISSING_DEPS+=("$dep")
    fi
done

if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
    echo "[ERROR] Missing required dependencies: ${MISSING_DEPS[*]}"
    exit 1
fi

echo "[INFO] Starting system bootstrap setup..."

# Iterate through modules
for module_path in "$MODULES_DIR"/*; do
    if [[ ! -d "$module_path" ]]; then
        continue
    fi

    module_name=$(basename "$module_path")

    # Run Lifecycle Stages
    run_stage "pre-install"  "$module_path/pre.sh"     "$module_name" || exit 1
    run_stage "installation" "$module_path/install.sh" "$module_name" || exit 1
    run_stage "post-install" "$module_path/post.sh"    "$module_name" || exit 1
done

echo "[OK] System bootstrap completed successfully!"


