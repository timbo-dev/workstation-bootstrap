#!/usr/bin/env bash

set -euo pipefail

# Load utilities
source "$(dirname "$0")/lib/utils.sh"

MODULES_DIR="$(dirname "$0")/modules"

if [[ ! -d "$MODULES_DIR" ]]; then
    echo "[ERROR] Modules directory not found: $MODULES_DIR"
    exit 1
fi

# --- Root Elevation ---
if [[ $EUID -ne 0 ]]; then
    log_info "Re-running script as root..."
    exec sudo "$0" "$@"
fi

# --- User Detection ---
REAL_USER=${SUDO_USER:-$(awk -F: '$3 >= 1000 && $3 != 65534 {print $1; exit}' /etc/passwd)}
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

if [[ -z "$REAL_USER" ]]; then
    log_error "Could not detect a valid non-root user."
    exit 1
fi

export REAL_USER
export REAL_HOME

log_info "Bootstrap environment initialized."
log_info "Real User: $REAL_USER | Home: $REAL_HOME"

# --- Pre-flight Checks ---
wait_for_pacman

REQUIRED_DEPS=("git" "awk" "getent")
MISSING_DEPS=()
for dep in "${REQUIRED_DEPS[@]}"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        MISSING_DEPS+=("$dep")
    fi
done

if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
    log_error "Missing required dependencies: ${MISSING_DEPS[*]}"
    exit 1
fi

log_info "Starting system bootstrap setup..."

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


