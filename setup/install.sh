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
    echo -e "${BLUE}[INFO] Re-running script as root...${NC}"
    exec sudo "$0" "$@"
fi

# --- User Detection ---
# 1. Check SUDO_USER
# 2. Fallback to the first user with UID >= 1000
REAL_USER=${SUDO_USER:-$(awk -F: '$3 >= 1000 && $3 != 65534 {print $1; exit}' /etc/passwd)}
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

if [[ -z "$REAL_USER" ]]; then
    echo -e "${RED}[ERROR] Could not detect a valid non-root user.${NC}"
    exit 1
fi

export REAL_USER
export REAL_HOME

echo -e "${BLUE}[INFO] Operating as root.${NC}"
echo -e "${BLUE}[INFO] Target user: $REAL_USER (Home: $REAL_HOME)${NC}"

# --- Sudo Keep-Alive (optional but helpful for nested sudo) ---
(while true; do sudo -n -v; sleep 20; kill -0 "$$" || exit; done) 2>/dev/null &
SUDO_KEEP_ALIVE_PID=$!
trap 'kill $SUDO_KEEP_ALIVE_PID 2>/dev/null || true' EXIT

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


