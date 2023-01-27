#!/bin/sh

DATA_OPENVPN="/data/openvpn/"
DATA_SODIRA="/data/Sodira/"
ETC_OPENVPN="/etc/openvpn/"

if [ ! -d "$DATA_OPENVPN" ]; then

  mkdir -p $DATA_OPENVPN

cat << EOF > $DATA_OPENVPN/readme-first

Put your client.conf vpn configuration in /data/openvpn

EOF

fi

if [ ! -d "$DATA_SODIRA" ]; then

  mkdir -p $DATA_SODIRA

cat << EOF > $DATA_SODIRA/readme-first

Put your RootCA, certs and keys in /data/Sodira

EOF

fi

systemctl enable openvpn@client.service

#STATUS="$(systemctl is-active openvpn@client.service)"
#if [ "${STATUS}" = "active" ]; then
#    echo "service openvpn is active"
#else
#    systemctl enable openvpn@client.service
#    exit 1
#fi
