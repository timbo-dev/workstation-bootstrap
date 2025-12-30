#!/usr/bin/env bash

set -euo pipefail

# Source utils for logging and helpers
source "$(dirname "$0")/../../lib/utils.sh"

log_info "Installing rust..."

asdf_user_setup "rust" "https://github.com/code-lever/asdf-rust.git"
