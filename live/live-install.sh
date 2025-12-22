#!/usr/bin/env bash

set -euo pipefail

CALAMARES_DIR="/etc/calamares"
SETTINGS="$CALAMARES_DIR/settings.conf"

LANGUAGE="pt_BR.UTF-8"
REGION="America"
ZONE="Sao_Paulo"

KEYBOARD_LAYOUT="br"
KEYBOARD_VARIANT="abnt2"
KEYBOARD_MODEL="pc105"

USER_FULL_NAME="Timbo"
USER_LOGIN_NAME="timbo-dev"
USER_FIELDS_EDITABLE="false"

if [[ $EUID -ne 0 ]]; then
    echo "Execute o script como root (sudo)"
    exit 1
fi

echo "[INFO] Rodando no Live Environment"
echo "[INFO] Forçando idioma do Calamares: $LANGUAGE"

LOCALE_FILE="$CALAMARES_DIR/modules/locale.conf"
KEYBOARD_FILE="$CALAMARES_DIR/modules/keyboard.conf"
USERS_FILE="$CALAMARES_DIR/modules/users.conf"

echo "[INFO] Configurando locale do sistema instalado"
cat > "$LOCALE_FILE" <<EOF
---
region: $REGION
zone: $ZONE
EOF

echo "[INFO] Configurando keyboard do sistema instalado"
cat > "$KEYBOARD_FILE" <<EOF
---
layout: $KEYBOARD_LAYOUT
variant: $KEYBOARD_VARIANT
model: $KEYBOARD_MODEL
EOF

echo "[INFO] Configurando usuário e sudo"
cat > "$USERS_FILE" <<EOF
---
defaultGroups:
  - wheel
  - users
autologinGroup: autologin
sudoersGroup: wheel
sudoersConfigureWithGroup: true
displayAutologin: true
doAutologin: true
setRootPassword: false
doReusePassword: false
allowWeakPasswords: true
allowWeakPasswordsDefault: true
presets:
  fullName:
    value: $USER_FULL_NAME
    editable: $USER_FIELDS_EDITABLE
  loginName:
    value: $USER_LOGIN_NAME
    editable: $USER_FIELDS_EDITABLE
EOF

# Adiciona sudo temporário sem senha
echo "$USER_LOGIN_NAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/temp-nopasswd
chmod 440 /etc/sudoers.d/temp-nopasswd

echo "[INFO] Reiniciando Calamares"

pkill calamares || true
sleep 1

# Go to root to avoid mount path issues
cd /

# Ensure /mnt exists
mkdir -p /mnt

export LANG="$LANGUAGE"
export LC_ALL="$LANGUAGE"

sudo -E calamares -d &
