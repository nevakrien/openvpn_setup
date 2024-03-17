#!/bin/bash

# Check if the VPN configuration file argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 /path/to/vpnconfig.ovpn"
    exit 1
fi

VPN_CONFIG=$1
CREDENTIALS_FILE="/path/to/your/vpn-auth.txt"
NAMESPACE="mynamespace"

# Start OpenVPN within the namespace using the provided VPN configuration file
ip netns exec $NAMESPACE openvpn --config "$VPN_CONFIG" --auth-user-pass "$CREDENTIALS_FILE" --auth-nocache
