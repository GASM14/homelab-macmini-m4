#!/bin/bash
# Backup script for homelab volumes and configurations

BACKUP_DIR="/Volumes/CrucialX9/backups/$(date +%Y%m%d_%H%M%S)"
CONFIG_DIRS=(
    "/Volumes/CrucialX9/logtide"
    "/Volumes/CrucialX9/suricata"
    "/Volumes/CrucialX9/pihole"
)

echo "📦 Starting backup at $(date)"

mkdir -p "$BACKUP_DIR"

for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "📁 Backing up $dir"
        cp -r "$dir" "$BACKUP_DIR/"
    else
        echo "⚠️  Directory $dir does not exist, skipping"
    fi
done

echo "✅ Backup completed successfully"
echo "📂 Backup stored at: $BACKUP_DIR"
