14:25 19 October 2025

# Final universal device creation script 


Create the script file:

sudo nano /usr/local/bin/wg-add-client


# Main body of process
----------------------


#!/bin/bash
SERVER_PUBLIC_KEY="6LGaK3hX1/Y3zefxUdcddaeD/PuRK+F9jsE8P6/gZ3M="
SERVER_IP="37.59.96.34"

echo "=== WIREGUARD CLIENT CREATOR WITH QR ==="
read -p "Enter client name: " CLIENT_NAME
read -p "Enter client IP (e.g., 10.0.0.X): " CLIENT_IP

# Generate keys
CLIENT_PRIVATE=$(wg genkey)
CLIENT_PUBLIC=$(echo "$CLIENT_PRIVATE" | wg pubkey)

echo "Client Private Key: $CLIENT_PRIVATE"
echo "Client Public Key: $CLIENT_PUBLIC"

# Create directory
sudo mkdir -p /etc/wireguard/clients

# Create client config
sudo tee /etc/wireguard/clients/${CLIENT_NAME}.conf > /dev/null << EOF
[Interface]
PrivateKey = $CLIENT_PRIVATE
Address = $CLIENT_IP/32
DNS = 8.8.8.8, 8.8.4.4

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
Endpoint = $SERVER_IP:51820
AllowedIPs = 10.0.0.0/24
EOF

sudo chmod 600 /etc/wireguard/clients/${CLIENT_NAME}.conf

# Add to server config
sudo tee -a /etc/wireguard/wg0.conf > /dev/null << EOF

[Peer]
# $CLIENT_NAME
PublicKey = $CLIENT_PUBLIC
AllowedIPs = $CLIENT_IP/32
EOF

# Restart WireGuard
sudo wg-quick down wg0
sudo wg-quick up wg0

echo "=== CLIENT CREATED SUCCESSFULLY ==="
echo "Config: /etc/wireguard/clients/${CLIENT_NAME}.conf"
echo "Client IP: $CLIENT_IP"

# Generate QR code
echo ""
echo "=== QR CODE ==="
if command -v qrencode &> /dev/null; then
    qrencode -t ansiutf8 < /etc/wireguard/clients/${CLIENT_NAME}.conf
else
    echo "Install qrencode for QR codes: sudo apt install qrencode"
    echo ""
    echo "=== CONFIG CONTENT ==="
    sudo cat /etc/wireguard/clients/${CLIENT_NAME}.conf
fi

echo ""
echo "=== WIREGUARD STATUS ==="
sudo wg show


-------------- END  - sudo chmod +x /usr/local/bin/wg-add-client # MAKE EXE

Run application - Example Usage:

wg-add-client

Client name: phone

Client IP: 10.0.0.4

Summary: 

# 1. Create the script file
sudo nano /usr/local/bin/wg-add-client

# 2. Paste the script content (copy from above)

# 3. Make executable
sudo chmod +x /usr/local/bin/wg-add-client

# 4. Install QR code support
sudo apt install qrencode -y

# 5. Test it!
wg-add-client


