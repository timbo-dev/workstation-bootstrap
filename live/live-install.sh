#!/usr/bin/env bash

set -euo pipefail

CALAMARES_DIR="/etc/calamares"
BACKUP_DIR="/tmp/calamares-backup"
SETTINGS="$CALAMARES_DIR/settings.conf"

LANGUAGE="pt_BR.UTF-8"
REGION="America"
ZONE="Sao_Paulo"

if [[ $EUID -ne 0 ]]; then
    echo "Execute o script como root (sudo)"
    exit 1
fi

echo "[INFO] Rodando no Live Environment"

if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "[INFO] Criando backup do Calamares"
    cp -a "$CALAMARES_DIR" "$BACKUP_DIR"
fi

echo "[INFO] Forçando idioma do Calamares: $LANGUAGE"

export LANG="$LANGUAGE"
export LC_ALL="$LANGUAGE"

LOCALE_FILE="$CALAMARES_DIR/modules/locale.conf"
KEYBOARD_FILE="$CALAMARES_DIR/modules/keyboard.conf"

echo "[INFO] Configurando locale do sistema instalado"

cat > "$LOCALE_FILE" <<EOF
---
region: $REGION
zone: $ZONE
EOF

echo "[INFO] Configurando keyboard do sistema instalado"

cat > "$KEYBOARD_FILE" <<EOF
---
layout: br
variant: abnt2
model: pc105
EOF

echo "[INFO] Reiniciando Calamares"

pkill calamares || true
sleep 1

LANG="$LANGUAGE" LC_ALL="$LANGUAGE" sudo calamares &