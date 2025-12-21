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
variant: $KEYBOARD_LAYOUT
model: $KEYBOARD_MODEL
EOF

echo "[INFO] Configurando user do sistema instalado"
cat > "$USERS_FILE" <<EOF
---
presets:
    fullName:
        value: $USER_FULL_NAME
        editable: $USER_FIELDS_EDITABLE

    loginName:
        value: $USER_LOGIN_NAME
        editable: $USER_FIELDS_EDITABLE
EOF

echo "[INFO] Reiniciando Calamares"

pkill calamares || true
sleep 1

# Go to root to avoid mount path issues
cd /

export LANG="$LANGUAGE"
export LC_ALL="$LANGUAGE"

# Ensure /mnt exists
mkdir -p /mnt

LANG="$LANGUAGE" LC_ALL="$LANGUAGE" sudo calamares &