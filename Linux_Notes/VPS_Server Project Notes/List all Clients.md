#!/bin/bash
echo "=== WIREGUARD CLIENTS ==="
sudo ls /etc/wireguard/clients/*.conf 2>/dev/null | xargs -n 1 basename
echo ""
echo "=== ACTIVE CONNECTIONS ==="
sudo wg show


		   # sudo chmod +x /usr/local/bin/wg-list-clients
		   # sudo nano /usr/local/bin/wg-list-clients