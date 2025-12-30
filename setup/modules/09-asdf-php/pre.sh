#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/../../lib/utils.sh"

log_info "Preparing PHP for asdf installation..."

# Ensure plocate is installed to use locate command
pacman_install "plocate"

log_info "Prepared PHP for asdf installation."
