#!/bin/bash

# Backup configuration
BACKUP_DIR="/mnt/data/system-backup"
LOG_FILE="/var/log/system-backup.log"

echo "=== Starting System Backup: $(date) ===" | tee -a "$LOG_FILE"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Perform the backup with rsync
sudo rsync -aAXhv --progress \
    --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} \
    --exclude={"/var/cache/*","/var/tmp/*","/swapfile","*.tmp",".cache/*"} \
    --exclude="/var/log/*" \
    --delete \
    --log-file="$LOG_FILE" \
    / "$BACKUP_DIR/"

# Create backup info file
echo "Backup created: $(date)" > "$BACKUP_DIR/backup-info.txt"
echo "Source: $(hostname) - /dev/sda1" >> "$BACKUP_DIR/backup-info.txt"
echo "Destination: $BACKUP_DIR" >> "$BACKUP_DIR/backup-info.txt"
df -h >> "$BACKUP_DIR/backup-info.txt"

echo "=== Backup Completed: $(date) ===" | tee -a "$LOG_FILE"
echo "Backup size: $(du -sh $BACKUP_DIR)" | tee -a "$LOG_FILE"

# Verify critical directories were backed up
echo "=== Backup Verification ===" | tee -a "$LOG_FILE"
ls -la "$BACKUP_DIR"/{etc,home,var,usr,boot,root} 2>/dev/null | head -10 | tee -a "$LOG_FILE"
