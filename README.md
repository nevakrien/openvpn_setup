# openvpn_setup
trying to make a multi endpoint scraper with my nordvpn acount

# setup
if you are using nordvpn
go folow nordvpns official guide on how to set it up https://support.nordvpn.com/hc/en-us/articles/19683394518161-OpenVPN-connection-on-NordVPN


docker build -t my-nordvpn .
docker run --cap-add=NET_ADMIN --device=/dev/net/tun --network="bridge" --name=my-nordvpn-container -d my-nordvpn


# test


docker exec my-nordvpn-container curl ipinfo.io

curl ipinfo.io

