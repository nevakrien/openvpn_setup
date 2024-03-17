#!/bin/bash

# Check if the VPN configuration file argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 /path/to/vpnconfig.ovpn"
    exit 1
fi

VPN_CONFIG=$1
NAMESPACE="mynamespace"

# Start OpenVPN within the namespace using the provided VPN configuration file
ip netns exec $NAMESPACE openvpn --config "$VPN_CONFIG" --auth-user-pass /dev/stdin --auth-nocache --script-security 2 --up auth-script.sh

