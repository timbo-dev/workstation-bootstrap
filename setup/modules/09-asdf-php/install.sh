#!/usr/bin/env bash

set -euo pipefail

# Source utils for logging and helpers
source "$(dirname "$0")/../../lib/utils.sh"

log_info "Installing php..."

asdf_user_setup "php" "https://github.com/asdf-community/asdf-php.git"

log_info "PHP installed successfully."