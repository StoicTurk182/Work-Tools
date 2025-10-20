#!/bin/bash
PHONE_IP="10.0.0.4"
SERVER_PUBLIC_KEY="6LGaK3hX1/Y3zefxUdcddaeD/PuRK+F9jsE8P6/gZ3M="
SERVER_IP="37.59.96.34"

echo "=== CREATING PHONE CONFIG ==="

# Generate keys
PHONE_PRIVATE=$(wg genkey)
PHONE_PUBLIC=$(echo "$PHONE_PRIVATE" | wg pubkey)

echo "Phone Private Key: $PHONE_PRIVATE"
echo "Phone Public Key: $PHONE_PUBLIC"

# Create directory
sudo mkdir -p /etc/wireguard/clients

# Create phone config
sudo tee /etc/wireguard/clients/phone.conf > /dev/null << EOF
[Interface]
PrivateKey = $PHONE_PRIVATE
Address = $PHONE_IP/32
DNS = 8.8.8.8, 8.8.4.4

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
Endpoint = $SERVER_IP:51820
AllowedIPs = 10.0.0.0/24
EOF

sudo chmod 600 /etc/wireguard/clients/phone.conf

# Add to server config
sudo tee -a /etc/wireguard/wg0.conf > /dev/null << EOF

[Peer]
# Phone
PublicKey = $PHONE_PUBLIC
AllowedIPs = $PHONE_IP/32
EOF

# Restart WireGuard
sudo wg-quick down wg0
sudo wg-quick up wg0

echo "=== PHONE CONFIG CREATED ==="
echo "Config: /etc/wireguard/clients/phone.conf"
echo "Phone IP: $PHONE_IP"

# Generate QR code
echo ""
echo "=== QR CODE ==="
qrencode -t ansiutf8 < /etc/wireguard/clients/phone.conf

