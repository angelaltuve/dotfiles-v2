#!/bin/bash

set -e

SECONDS=0

export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes

REPO="/mnt/borg-backup/artix"
EXCLUDE_FILE="/home/angel/.config/borg/exclude.txt"
ARCHIVE_NAME="artix-$(date +%Y-%m-%d)"
BACKUP_DIRS="/etc /home/angel /root /usr/local/bin"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# ─── Preliminaries ──────────────────────────────────────────────

echo "╔══════════════════════════════════════════════════════════╗"
echo "║           BACKUP BORG — $TIMESTAMP           ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo

if ! mountpoint -q /mnt; then
    echo "✗ ERROR: USB not mounted at /mnt"
    exit 1
fi
echo "✓ USB mounted at /mnt"

if [ ! -d "$REPO/data" ]; then
    echo "✗ ERROR: repo not found at $REPO"
    echo "  Run: borg init --encryption none $REPO"
    exit 1
fi
echo "✓ Repo found: $REPO"

echo "• Archive: $REPO::$ARCHIVE_NAME"
echo

# ─── Disk space ────────────────────────────────────────────────

echo "── Disk space (repo) ──"
df -h "$REPO" | tail -1 | awk '{print "  Free: "$4" of "$2" ("$5" used)"}'
echo

# ─── Directories to back up ────────────────────────────────────

echo "── Directories to back up ──"
for dir in $BACKUP_DIRS; do
    if [ -d "$dir" ]; then
        size=$(du -sh "$dir" 2>/dev/null | cut -f1)
        echo "  • $size  $dir"
    else
        echo "  •  —    $dir  (does not exist)"
    fi
done
echo

# ─── Exclusions ────────────────────────────────────────────────

NUM_EXCLUDES=$(grep -cEv '^\s*(#|$)' "$EXCLUDE_FILE")
echo "── Exclusions ($NUM_EXCLUDES patterns) ──"
echo "  File: $EXCLUDE_FILE"
echo

# ─── Previous backup (reference) ────────────────────────────────

LAST_ARCHIVE=$(borg list --short "$REPO" 2>/dev/null | tail -1)
if [ -n "$LAST_ARCHIVE" ]; then
    echo "── Previous backup ──"
    borg info "$REPO::$LAST_ARCHIVE" 2>/dev/null | grep -E '(Original size|Compressed size|Number of files|Time (start|end))' | sed 's/^/  /'
    echo
fi

# ─── Create backup ───────────────────────────────────────────────

echo "── Starting backup ─────────────────────────────────────"
echo

borg create \
    --verbose \
    --stats \
    --show-rc \
    --progress \
    --compression zstd,3 \
    --exclude-from "$EXCLUDE_FILE" \
    "$REPO::$ARCHIVE_NAME" \
    $BACKUP_DIRS

RC=$?
echo

if [ $RC -eq 0 ]; then
    echo "✓ Backup created successfully"
else
    echo "✗ Backup finished with code $RC"
fi
echo

# ─── Backup summary ─────────────────────────────────

echo "── Backup summary ──"
borg info "$REPO::$ARCHIVE_NAME" 2>/dev/null | grep -E '(Original size|Compressed size|Deduplicated size|Number of files|Time (start|end))' | sed 's/^/  /'
echo

# ─── Disk space after backup ────────────────────────────────

echo "── Disk space (post-backup) ──"
df -h "$REPO" | tail -1 | awk '{print "  Free: "$4" of "$2" ("$5" used)"}'
echo

# ─── Prune ──────────────────────────────────────────────────────

echo "── Pruning old backups ────────────────────────────"
echo "  Policy: keep 8 weekly + 6 monthly + 2 yearly"
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

# ─── Final listing ────────────────────────────────────────────────

DURATION=$SECONDS
echo "── Backup completed in $((DURATION / 60))m $((DURATION % 60))s ──"
echo
borg list "$REPO"
echo
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                    BACKUP FINALIZADO                     ║"
echo "╚══════════════════════════════════════════════════════════╝"
