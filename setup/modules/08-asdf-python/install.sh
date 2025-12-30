#!/usr/bin/env bash

set -euo pipefail

# Source utils for logging and helpers
source "$(dirname "$0")/../../lib/utils.sh"

log_info "Installing python..."

asdf_user_setup "python" "https://github.com/asdf-community/asdf-python.git"

log_info "Python installed successfully."