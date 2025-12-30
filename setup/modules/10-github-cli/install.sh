#!/usr/bin/env bash

set -euo pipefail

# Source utils for logging and helpers
source "$(dirname "$0")/../../lib/utils.sh"

log_info "Installing github-cli..."

# Ensure github-cli is installed pacman package manager
pacman_install "github-cli"

log_info "github-cli installed successfully."
