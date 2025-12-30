#!/usr/bin/env bash

# ANSI colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
CLEAR_LINE='\033[K'

# Professional Logging
log_info()  { echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] [INFO]  $*${NC}"; }
log_warn()  { echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] [WARN]  $*${NC}"; }
log_error() { echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] [ERROR] $*${NC}"; }

# Safe Pacman Lock Wait
wait_for_pacman() {
    local lock_file="/var/lib/pacman/db.lck"
    if [[ -f "$lock_file" ]]; then
        log_warn "Pacman lock file detected. Waiting for other processes..."
        while [[ -f "$lock_file" ]]; do
            sleep 2
        done
        log_info "Pacman lock released."
    fi
}

run_as_user() {
    local cmd="$1"
    if [[ -z "${REAL_USER:-}" ]]; then
        log_error "REAL_USER not set. Cannot drop privileges."
        return 1
    fi
    # Use -l to simulate a full login shell for correct $HOME and PATH
    runuser -l "$REAL_USER" -c "$cmd"
}

asdf_user_setup() {
    local plugin="$1"
    local url="$2"
    local version="${3:-latest}"

    run_as_user "
        # Source asdf if not in path (login shell usually has it, but being safe)
        for s in '/opt/asdf-vm/asdf.sh' \"\$HOME/.asdf/asdf.sh\"; do
            if [ -f \"\$s\" ]; then . \"\$s\"; break; fi
        done

        if ! command -v asdf >/dev/null; then
            echo \"[ERROR] asdf not found. Cannot install $plugin.\"
            exit 1
        fi

        echo \"Adding $plugin plugin...\"
        asdf plugin add \"$plugin\" \"$url\" || true

        echo \"Installing $plugin \$version...\"
        asdf install \"$plugin\" \"$version\"

        echo \"Setting $plugin \$version as home default...\"
        asdf set --home \"$plugin\" \"$version\"
    "
}

ensure_line_in_file() {
    local line="$1"
    local file="$2"
    
    # Ensure directory exists
    mkdir -p "$(dirname "$file")"
    touch "$file"

    if ! grep -Fxq "$line" "$file"; then
        echo "$line" >> "$file"
        echo "[INFO] Added line to $file: $line"
    else
        echo "[DEBUG] Line already exists in $file: $line"
    fi
    return 0
}

run_stage() {
    local stage_name="$1"
    local script_path="$2"
    local module_name="$3"

    if [[ ! -f "$script_path" ]]; then
        return 0
    fi

    echo -e "${GREEN}==>${NC} ${YELLOW}Starting ($module_name) $stage_name...${NC}"
    echo "--------------------------------------------------------------------------------"

    if bash "$script_path"; then
        echo "--------------------------------------------------------------------------------"
        echo -e "${GREEN}[OK]   ($module_name) $stage_name completed successfully!${NC}"
        echo ""
        return 0
    else
        echo "--------------------------------------------------------------------------------"
        echo -e "${RED}[FAIL] ($module_name) $stage_name failed!${NC}"
        echo ""
        return 1
    fi
}
