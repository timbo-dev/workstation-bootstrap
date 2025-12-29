#!/usr/bin/env bash

source "$(dirname "$0")/../../lib/utils.sh"

echo "Configuring ZSH for asdf..."

ZSHRC="$HOME/.zshrc"

# Core ZSH Autocompletion
ensure_line_in_file "autoload -Uz compinit" "$ZSHRC"
ensure_line_in_file "compinit" "$ZSHRC"
ensure_line_in_file "zstyle ':completion:*' menu select" "$ZSHRC"
ensure_line_in_file "zstyle ':completion::complete:*' gain-privileges 1" "$ZSHRC"

# asdf PATH and shims
ensure_line_in_file 'export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"' "$ZSHRC"
