#!/bin/bash

# Namespace and network configuration
NAMESPACE="mynamespace"
HOST_IFACE="veth-host"
NS_IFACE="veth-ns"
HOST_IP="10.200.200.1"
NS_IP="10.200.200.2"
DNS_IP="8.8.8.8"

# Default to auto-detecting the internet-facing interface
INTERFACE_MODE=${1:-auto}
DEFAULT_IFACE=""

if [ "$INTERFACE_MODE" == "auto" ]; then
    # Auto-detect the default network interface
    DEFAULT_IFACE=$(ip route | grep default | awk '{print $5}')
else
    # Use the manually specified interface
    DEFAULT_IFACE="$INTERFACE_MODE"
fi

# Check if the interface is Wi-Fi or Ethernet
if [[ $(iwconfig $DEFAULT_IFACE 2>&1) =~ "no wireless extensions." ]]; then
    CONN_TYPE="Ethernet"
else
    CONN_TYPE="Wi-Fi"
fi

echo "Detected connection type: $CONN_TYPE on interface $DEFAULT_IFACE"

# Delete the existing namespace if it exists
ip netns list | grep -q $NAMESPACE && ip netns del $NAMESPACE

# Create a new namespace
ip netns add $NAMESPACE

# Create veth pair and attach one end to the namespace
ip link add $HOST_IFACE type veth peer name $NS_IFACE
ip link set $NS_IFACE netns $NAMESPACE

# Configure the host side of the veth pair
ip addr add $HOST_IP/24 dev $HOST_IFACE
ip link set $HOST_IFACE up

# Configure the namespace side of the veth pair
ip netns exec $NAMESPACE ip addr add $NS_IP/24 dev $NS_IFACE
ip netns exec $NAMESPACE ip link set $NS_IFACE up

# Bring up loopback interface within the namespace
ip netns exec $NAMESPACE ip link set lo up

# Configure the default route within the namespace
ip netns exec $NAMESPACE ip route add default via $HOST_IP

# Enable IP forwarding and set up NAT
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -s $NS_IP/24 -o $DEFAULT_IFACE -j MASQUERADE

# Set DNS for the namespace
mkdir -p /etc/netns/$NAMESPACE
echo "nameserver $DNS_IP" > /etc/netns/$NAMESPACE/resolv.conf

echo "Namespace $NAMESPACE is set up and ready for use."
