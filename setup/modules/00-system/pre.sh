#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/../../lib/utils.sh"

echo "Configuring System before installation for user $REAL_USER..."

# Configure shell for user
chsh -s $(which zsh) $REAL_USER
