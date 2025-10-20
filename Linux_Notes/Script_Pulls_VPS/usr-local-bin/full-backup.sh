#!/bin/bash
BACKUP_DIR="/mnt/VPS-BACKUP"
DATE=$(date +%Y%m%d)

# Create filesystem backup
sudo fsarchiver savefs $BACKUP_DIR/vps-full-$DATE.fsa /dev/sda1 /dev/sda2

# Keep only last 7 backups
find $BACKUP_DIR -name "vps-full-*.fsa" -type f -mtime +7 -delete
