#!/bin/bash
echo "=== SIMPLE SYSTEM BACKUP ==="
DATE=$(date +%Y%m%d)

# Backup essential system
echo "1. Backing up essential system..."
sudo tar -czf /backup/system-essential-$DATE.tar.gz \
    /etc /home /root /var /usr/local /opt 2>/dev/null

# Backup WireGuard specifically  
echo "2. Backing up WireGuard..."
sudo tar -czf /backup/wireguard-$DATE.tar.gz /etc/wireguard /usr/local/bin/wg-*.sh 2>/dev/null

# Backup package list
echo "3. Backing up package list..."
dpkg --get-selections > /backup/packages-$DATE.txt

echo ""
echo "=== BACKUP COMPLETE ==="
ls -lh /backup/*-$DATE.*
