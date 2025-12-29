#!/usr/bin/env bash

set -euo pipefail

MODULE_NAME=${1:-}
MODULES_DIR="setup/modules"

if [[ -z "$MODULE_NAME" ]]; then
    echo "Usage: $0 <module-name>"
    exit 1
fi

# Determine next number
LAST_NUM=$(ls "$MODULES_DIR" | grep -E "^[0-9]{2}-" | tail -1 | cut -d- -f1 || echo "00")
NEXT_NUM=$(printf "%02d" $((10#$LAST_NUM + 1)))

FULL_NAME="${NEXT_NUM}-${MODULE_NAME}"
TARGET_DIR="${MODULES_DIR}/${FULL_NAME}"

echo "Creating module: ${FULL_NAME} in ${TARGET_DIR}..."

mkdir -p "$TARGET_DIR"

# Template for scripts
create_script() {
    local script_name="$1"
    local description="$2"
    local file_path="${TARGET_DIR}/${script_name}.sh"

    cat <<EOF > "$file_path"
#!/usr/bin/env bash

set -euo pipefail

# Source utils for logging and helpers
source "\$(dirname "\$0")/../../lib/utils.sh"

log_info "${description}..."

# Your code here
EOF
    chmod +x "$file_path"
}

create_script "pre" "Pre-install configuration for ${MODULE_NAME}"
create_script "install" "Installing ${MODULE_NAME}"
create_script "post" "Post-install configuration for ${MODULE_NAME}"

echo "[OK] Module ${FULL_NAME} created successfully!"
