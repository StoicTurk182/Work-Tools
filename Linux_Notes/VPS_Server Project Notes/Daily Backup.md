13:04 20 October 2025   sudo fsarchiver archinfo /mnt/local-backup/vps-root-20251020-121550.fsa

====================== archive information ======================
Archive type:                   filesystems
Filesystems count:              1
Archive id:                     68fcc1e1
Archive file format:            FsArCh_002
Archive created with:           0.8.8
Archive creation date:          2025-10-20_12-15-50
Archive label:                  <none>
Minimum fsarchiver version:     0.6.4.0
Compression level:              8 (zstd level 8)
Encryption algorithm:           none

===================== filesystem information ====================
Filesystem id in archive:       0
Filesystem format:              ext4
Filesystem label:
Filesystem uuid:                3e1076d9-4f16-40db-91f0-82fb6dc85c5b
Original device:                /dev/sda1
Original filesystem size:       98.22 GB (105467994112 bytes)
Space used in filesystem:       8.62 GB (9257771008 bytes)


sudo mkdir -p /mnt/local-backup
sudo mount /dev/sdb1 /mnt/local-backup


sudo nano /usr/local/bin/local-backup.sh

---------------- Begin

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

sudo chmod +x /usr/local/bin/local-backup.sh


sudo /usr/local/bin/local-backup.sh

Type	Speed	Safety	Use Case
Local (/dev/sdb1)	Very Fast	Lower (same hardware)	Quick snapshots, rapid recovery
Remote (SMB share)	Slower	Higher (off-site)	Disaster recovery

---------------- End

					Recovery: sudo fsarchiver restfs /mnt/local-backup/vps-root-20251020-114326.fsa id=0,dest=/dev/sda1
					
					
OVH Method
					
# Mount your backup drive
					
mkdir -p /mnt/restore
mount /dev/sdb1 /mnt/restore

# List available backups
ls -lh /mnt/restore/vps-root-*.fsa

# Restore latest backup
sudo fsarchiver restfs /mnt/restore/vps-root-latest.fsa id=0,dest=/dev/sda1



