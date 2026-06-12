#!/bin/bash

set -e

export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes

REPO="/mnt/borg-backup/artix"
EXCLUDE_FILE="/home/angel/.config/borg/exclude.txt"
ARCHIVE_NAME="artix-$(date +%Y-%m-%d)"
BACKUP_DIRS="/etc /home/angel /root /usr/local/bin"

if ! mountpoint -q /mnt; then
    echo "ERROR: USB no montada en /mnt"
    exit 1
fi

if [ ! -d "$REPO/data" ]; then
    echo "ERROR: repo no encontrado en $REPO"
    echo "Ejecutá: borg init --encryption none $REPO"
    exit 1
fi

echo "=== Backup: $ARCHIVE_NAME ==="
echo

borg create \
    --verbose \
    --stats \
    --show-rc \
    --compression zstd,3 \
    --exclude-from "$EXCLUDE_FILE" \
    "$REPO::$ARCHIVE_NAME" \
    $BACKUP_DIRS

echo
echo "=== Podando backups antiguos ==="
echo

borg prune \
    --verbose \
    --list \
    --show-rc \
    --keep-weekly 8 \
    --keep-monthly 6 \
    --keep-yearly 2 \
    "$REPO"

echo
echo "=== Backup completado ==="
borg list "$REPO"
