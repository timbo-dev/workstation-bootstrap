#!/usr/bin/env bash

set -euo pipefail

# Source utils for logging and helpers
source "$(dirname "$0")/../../lib/utils.sh"

log_info "Installing pnpm..."

asdf_user_setup "pnpm" "https://github.com/jonathanmorley/asdf-pnpm.git"

log_info "pnpm installed successfully."
