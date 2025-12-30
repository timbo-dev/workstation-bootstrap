#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/../../lib/utils.sh"

log_info "Installing Node.js..."

asdf_user_setup "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
