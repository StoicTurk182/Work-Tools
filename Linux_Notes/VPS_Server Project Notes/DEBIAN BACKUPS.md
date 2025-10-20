15:12 19 October 2025

df -h --total | grep total

# !Optimised backup command! # 

sudo rsync -aAXhv --progress \
  --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/Resync backup"} \
  / "/Resync backup/"

#  Run backup - 
sudo backup-simple.sh

sudo rsync -av /etc/ssh/ /etc/ssh_backup/ # for ssh




# Use find to reliably locate all backup files

sudo find /backup -name "*.tar.gz" -type f | while read file; do
    sudo tar -tzf "$file" > /dev/null 2>&1 && echo "✅ $(basename "$file")" || echo "❌ $(basename "$file")" 
 
 
 Primary backup
 --------------
 
		 # Create optimized system image (will be small)
sudo tar -czf /backup/images/debian-small-$(date +%Y%m%d).tar.gz \
    --exclude=/backup \
    --exclude=/proc --exclude=/sys --exclude=/dev \
    --exclude=/tmp --exclude=/run --exclude=/mnt \
    --exclude=/media --exclude=/lost+found \
    --exclude=/var/cache --exclude=/var/tmp \
    --exclude=/var/log/*.log --exclude=/home/*/.cache \
    --exclude=/swapfile \
    /

# Check the actual size
ls -lh /backup/images/debian-small-*.tar.gz
 
 
 --------------

	



	
		  sudo tar -xzpvf /backup/debian-essential-20241018.tar.gz -C /
		 
		  sudo nano /usr/local/bin/backup-simple.sh
		  
		  sudo chmod +x /usr/local/bin/backup-simple.sh
		 			    
		  ls -la /backup/
		  
		  


# Check the actual size
ls -lh /backup/images/debian-small-*.tar.gz

--------------------------------------- 15:27 19 October 2025


# Verifications   - sudo ls -la /backup/ /backup/images/ /backup/wireguard/ /backup/system/ 2>/dev/null

# Should show ~2-3GB, NOT 100GB
ls -lh /backup/images/debian-small-*.tar.gz

# Check contents
sudo tar -tzf /backup/images/debian-small-*.tar.gz | wc -l

# Test tar archive without extracting
sudo tar -tzf /backup/images/debian-small-*.tar.gz > /dev/null && echo "✅ Tar archive is valid" || echo "❌ Tar archive is corrupted"

# Verbose check
sudo tar -tzvf /backup/images/debian-small-*.tar.gz | tail -5

*****************************************

# Final verification with all details

    # Use find to reliably locate all backup files
sudo find /backup -name "*.tar.gz" -type f | while read file; do
    sudo tar -tzf "$file" > /dev/null 2>&1 && echo "✅ $(basename "$file")" || echo "❌ $(basename "$file")"


**************************************

# Restorations  

	Wiregaurd:
sudo tar -xzf /backup/wireguard-config-20251019.tar.gz -C /
sudo systemctl restart wg-quick@wg0


Systemctl: 
# Restore system configuration and data
sudo tar -xzpvf /backup/system-essential-20251019.tar.gz -C /


System Image: 
# Full system restore (use if system is broken)
sudo tar -xzpvf /backup/images/debian-optimized-20251019.tar.gz -C /

Conf: 
# Restore only configuration files
sudo tar -xzpvf /backup/configs-20251019.tar.gz -C /

# Restore package selections
sudo dpkg --set-selections < /backup/packages-20251019.txt
sudo apt-get update
sudo apt-get dselect-upgrade


-------------------------------------

Resync Backup integrity checks: 

# Final file count comparison
echo "Source file count:"
find / -type f 2>/dev/null | wc -l

echo "Backup file count:"
find /mnt/data/system-backup/ -type f 2>/dev/null | wc -l

# Check directory structure
sudo ls -la /mnt/data/system-backup/

# Verify no old directories remain
sudo ls -la /mnt/data/system-backup/ | grep -E "(Resync|backup)"

# Check backup size
sudo du -sh /mnt/data/system-backup/






