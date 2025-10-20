#!/bin/bash
BACKUP_DIR="/mnt/local-backup"
DATE=$(date +%Y%m%d-%H%M%S)

echo "=== Local backup to /dev/sdb1 ==="

# Backup using fsarchiver with -A flag
sudo fsarchiver -A savefs $BACKUP_DIR/vps-root-$DATE.fsa /dev/sda1

# Verify
if [ -f "$BACKUP_DIR/vps-root-$DATE.fsa" ]; then
    echo "SUCCESS: Local backup created"
    echo "Size: $(du -h $BACKUP_DIR/vps-root-$DATE.fsa | cut -f1)"
else
    echo "ERROR: Local backup failed"
fi
