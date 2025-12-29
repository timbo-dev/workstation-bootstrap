source "$(dirname "$0")/../../lib/utils.sh"

echo "Installing asdf from AUR..."

# Create a build directory accessible by the real user
BUILD_DIR=$(mktemp -d -p /tmp asdf-bootstrap-XXXX)
chown "$REAL_USER:$REAL_USER" "$BUILD_DIR"

# Use common helper to drop privileges
run_as_user "
    git clone https://aur.archlinux.org/asdf-vm.git '$BUILD_DIR'
    cd '$BUILD_DIR'
    makepkg -si --noconfirm
"

rm -rf "$BUILD_DIR"
