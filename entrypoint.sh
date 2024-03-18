#!/bin/sh

# Ensure the OpenVPN config file uses the correct credentials file
echo "auth-user-pass /etc/openvpn/vpn-auth.txt" >> /etc/openvpn/nordvpn.ovpn

# Start OpenVPN with the specified configuration
exec openvpn --config /etc/openvpn/nordvpn.ovpn
