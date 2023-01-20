#!/bin/sh

DATA_OPENVPN="/data/openvpn/"
ETC_OPENVPN="/etc/openvpn/"

if [ ! -d "$DATA_OPENVPN" ]; then

  mkdir -p $DATA_OPENVPN

cat << EOF > $DATA_OPENVPN/readme-first

Put your client vpn configuration client.conf in /data/openvpn/

EOF

fi

