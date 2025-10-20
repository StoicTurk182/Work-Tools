12:35 20 October 2025

				 !DISASTER RECOVERY!         (automated)

			  # Boot from Live USB, then:


sudo nano /usr/local/bin/manual-backup.sh


----------- End
		
gunzip -c /mnt/VPS-BACKUP/vps-root-20251020-114326.img.gz | dd of=/dev/sda1 bs=4M status=progress


# OVH

# Mount backup share
mkdir -p /mnt/backup
mount -t cifs -o credentials=/etc/samba/credentials //10.0.0.2/vps-backup /mnt/backup

# Restore image
gunzip -c /mnt/backup/vps-root-latest.img.gz | dd of=/dev/sda1 bs=4M status=progress

# Reboot
reboot

----------- Begin
		
#!/bin/bash
BACKUP_DIR="/mnt/VPS-BACKUP"
DATE=$(date +%Y%m%d-%H%M%S)
LOG_FILE="/var/log/backup.log"

echo "=== Starting manual backup at $(date) ===" | tee -a $LOG_FILE

if ! mountpoint -q $BACKUP_DIR; then
    echo "ERROR: Backup directory not mounted!" | tee -a $LOG_FILE
    exit 1
fi

echo "Creating compressed disk image of /dev/sda1..." | tee -a $LOG_FILE

# Create compressed backup using dd + gzip
sudo dd if=/dev/sda1 bs=4M status=progress | gzip > $BACKUP_DIR/vps-root-$DATE.img.gz

# Verify backup
if [ -f "$BACKUP_DIR/vps-root-$DATE.img.gz" ]; then
    echo "SUCCESS: Backup created: vps-root-$DATE.img.gz" | tee -a $LOG_FILE
    echo "Backup size: $(du -h $BACKUP_DIR/vps-root-$DATE.img.gz | cut -f1)" | tee -a $LOG_FILE
else
    echo "ERROR: Backup failed!" | tee -a $LOG_FILE
    exit 1
fi

echo "=== Backup completed at $(date) ===" | tee -a $LOG_FILE

-------- Begin

sudo chmod +x /usr/local/bin/manual-backup.sh

Run Backup 

sudo /usr/local/bin/manual-backup.sh
