23:24 19 October 2025

# Resync Backup

# Run the backup with proper exclusions
sudo rsync -aAXh --progress \
    --exclude=/dev \
    --exclude=/proc \
    --exclude=/sys \
    --exclude=/tmp \
    --exclude=/run \
    --exclude=/mnt \
    --exclude=/media \
    --exclude=/lost+found \
    --exclude=/swapfile \
    --exclude="*.tmp" \
    --exclude=".cache" \
    --delete \
    / /mnt/data/system-backup/


******************************************** 23:27 19 October 2025

		sudo nano /root/system-backup-rsync.sh


-------------------- BEGIN

	 #!/bin/bash

# System Backup Script using rsync
# Creates a complete system backup excluding temporary filesystems

echo "=== SYSTEM BACKUP SCRIPT ==="
echo "Starting backup: $(date)"
echo "Source: /"
echo "Destination: /mnt/data/system-backup/"
echo

# Check if destination exists
if [ ! -d "/mnt/data/system-backup" ]; then
    echo "Creating backup directory..."
    sudo mkdir -p /mnt/data/system-backup
fi

# Perform the backup
echo "Starting rsync backup..."
sudo rsync -aAXh --progress \
    --exclude=/dev \
    --exclude=/proc \
    --exclude=/sys \
    --exclude=/tmp \
    --exclude=/run \
    --exclude=/mnt \
    --exclude=/media \
    --exclude=/lost+found \
    --exclude=/swapfile \
    --exclude="*.tmp" \
    --exclude=".cache" \
    --delete \
    / /mnt/data/system-backup/

# Check exit status
if [ $? -eq 0 ]; then
    echo
    echo "✅ Backup completed successfully: $(date)"
    echo "Backup size: $(sudo du -sh /mnt/data/system-backup/)"
    echo "Backup location: /mnt/data/system-backup/"
else
    echo
    echo "❌ Backup failed with exit code: $?"
    echo "Please check the error messages above."
fi
------------------------- END


			   Make it executable
	sudo chmod +x /root/system-backup-rsync.sh

						Test Syntax
					   sudo bash -n /root/system-backup-rsync.sh


Execute - sudo /root/system-backup-rsync.sh					   


******************************************** 23:27 19 October 2025


sudo nano /mnt/data/restore-system-enhanced.sh

#!/bin/bash
echo "=== SYSTEM RESTORATION SCRIPT ==="
echo "WARNING: This will overwrite your current system!"
echo "Backup location: /mnt/data/system-backup/"
echo

# Check if backup exists
if [ ! -d "/mnt/data/system-backup" ]; then
    echo "ERROR: Backup directory not found!"
    echo "Please check that /mnt/data/system-backup exists."
    exit 1
fi

# Double confirmation
read -p "Are you sure you want to continue? (type 'YES' to confirm): " confirmation

if [ "$confirmation" != "YES" ]; then
    echo "Restoration cancelled."
    exit 1
fi

echo "Backup size: $(du -sh /mnt/data/system-backup/)"
read -p "Type 'RESTORE' for final confirmation: " final_confirm

if [ "$final_confirm" != "RESTORE" ]; then
    echo "Restoration cancelled."
    exit 1
fi

echo "Starting system restoration..."
sudo rsync -aAXhv --progress \
    --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*"} \
    /mnt/data/system-backup/ /

echo "Restoration complete. Post-restoration steps:"
echo "1. Update bootloader: sudo update-grub"
echo "2. Reinstall GRUB: sudo grub-install /dev/sda"
echo "3. Reboot the system: sudo reboot"
echo
echo "IMPORTANT: Test critical services after reboot!"

sudo chmod +x /mnt/data/restore-system-enhanced.sh

# Verify everything is in place
echo "=== BACKUP ECOSYSTEM ==="
ls -la /mnt/data/ | grep -E "(system-backup|restore)"
echo
echo "Your restoration script is ready at: /mnt/data/restore-system.sh"