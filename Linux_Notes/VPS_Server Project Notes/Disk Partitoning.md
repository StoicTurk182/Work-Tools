22:52 19 October 2025
---------------------

n          # Create new partition
p          # Primary partition
1          # Partition number (1)
           # Press Enter for first sector (default)
           # Press Enter for last sector (use entire disk)
w          # Write changes to disk and exit

Complete step-by-step in fdisk:
Type n and press Enter

Type p and press Enter

Type 1 and press Enter

Press Enter for first sector (accept default)

Press Enter for last sector (use entire disk)

Type w and press Enter to write and exit

# Format the partition
sudo mkfs.ext4 /dev/sdb1

# Create mount point
sudo mkdir /mnt/data

# Mount the disk
sudo mount /dev/sdb1 /mnt/data

Expected Result: 

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-209715199, default 2048): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-209715199, default 209715199): 
Created a new partition 1 of type 'Linux' and of size 100 GiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.


# 22:55 19 October 2025 (Resync backup on sdb) 

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



sudo chmod +x /root/backup-system.sh
sudo /root/backup-system.sh

Verification: 

# Check backup contents
sudo ls -la /mnt/data/system-backup/

# Verify critical directories
sudo ls -la /mnt/data/system-backup/{etc,home,root,boot,var}

# Check backup size
sudo du -sh /mnt/data/system-backup/

# Compare with source
sudo du -sh / /mnt/data/system-backup/


# Disaster recovery: 

#!/bin/bash
# WARNING: This script will overwrite your system!
# Only use for disaster recovery

-----------------------------

 #!/bin/bash
 
echo "=== SYSTEM RESTORATION SCRIPT ==="
echo "WARNING: This will overwrite your current system!"
echo "Backup location: /mnt/data/system-backup/"
echo
read -p "Are you sure you want to continue? (type 'YES' to confirm): " confirmation

if [ "$confirmation" != "YES" ]; then
    echo "Restoration cancelled."
    exit 1
fi

echo "Starting system restoration..."
sudo rsync -aAXhv --progress \
    --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*"} \
    /mnt/data/system-backup/ /

echo "Restoration complete. You may need to:"
echo "1. Update bootloader: sudo update-grub"
echo "2. Reinstall GRUB: sudo grub-install /dev/sda"
echo "3. Reboot the system"

-----------------------------

sudo chmod +x /mnt/data/restore-system.sh

# Compare File size: 

# Compare file counts (approximately)
echo "Source file count:"
find / -type f | wc -l

echo "Backup file count:"
find /mnt/data/system-backup/ -type f | wc -l

# Save Details 

sudo hostnamectl > /mnt/data/system-backup/system-info.txt
sudo blkid >> /mnt/data/system-backup/system-info.txt
sudo fdisk -l >> /mnt/data/system-backup/system-info.txt



