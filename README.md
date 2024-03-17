# openvpn_setup
trying to make a multi endpoint scraper with my nordvpn acount

# use

sudo ./setup_namespace.sh
sudo ./connect_vpn.sh ovpn_configs/us9178.nordvpn.com.udp1194.ovpn

# test

sudo ip netns exec mynamespace ping -c 4 8.8.8.8
