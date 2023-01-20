#!/bin/sh

DATA_OPENVPN="/data/openvpn/"
ETC_OPENVPN="/etc/openvpn/"

if [ ! -d "$DATA_OPENVPN" ]; then

  mkdir -p $DATA_OPENVPN

cat << EOF > $DATA_OPENVPN/readme-first

Put your client vpn configuration client.conf in /data/openvpn/

EOF

systemctl disable openvpn
systemctl enable openvpn@client
systemctl start openvpn@client

fi

