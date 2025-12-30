#!/usr/bin/env bash

set -euo pipefail

# Source utils for logging and helpers
source "$(dirname "$0")/../../lib/utils.sh"

log_info "Installing ruby..."

asdf_user_setup "ruby" "https://github.com/asdf-vm/asdf-ruby.git"

log_info "Ruby installed successfully."