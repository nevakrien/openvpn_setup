FROM alpine:latest

RUN apk --no-cache add openvpn curl

COPY entrypoint.sh /entrypoint.sh
COPY ca1187.nordvpn.com.udp.ovpn /etc/openvpn/nordvpn.ovpn
COPY vpn-auth.txt /etc/openvpn/vpn-auth.txt

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
