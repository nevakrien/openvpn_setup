#!/bin/bash

# Namespace and network configuration
NAMESPACE="mynamespace"
HOST_IFACE="veth-host"
NS_IFACE="veth-ns"
HOST_IP="10.200.200.1"
NS_IP="10.200.200.2"
DNS_IP="8.8.8.8"

# Delete the existing namespace if it exists
ip netns del $NAMESPACE 2>/dev/null

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
iptables -t nat -A POSTROUTING -s $NS_IP/24 -o eth0 -j MASQUERADE

# Set DNS for the namespace
mkdir -p /etc/netns/$NAMESPACE
echo "nameserver $DNS_IP" > /etc/netns/$NAMESPACE/resolv.conf

echo "Namespace $NAMESPACE is set up and ready for use."
