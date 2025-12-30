#!/usr/bin/env bash

set -euo pipefail

# Source utils for logging and helpers
source "$(dirname "$0")/../../lib/utils.sh"

log_info "Installing golang..."

asdf_user_setup "golang" "https://github.com/asdf-community/asdf-golang.git"

log_info "Golang installed successfully."
