#!/bin/bash

# Assign an IPv6 address to interface eth0
ip address add 2a04:0:0:10::3/64 dev eth1

# Add a default IPv6 route via the gateway
ip -6 route add default via 2a04:0:0:0010::1 dev eth1

# Add static hostname mappings for local services
echo 'fe80::200:ff:fe00:101 oldap.local' >> /etc/hosts
echo 'fe80::200:ff:fe00:102 syslog.local' >> /etc/hosts
echo 'fe80::200:ff:fe00:103 bind1.local'  > /etc/hosts
echo 'fe80::200:ff:fe00:104 wsa1.local'  >> /etc/hosts
echo 'fe80::200:ff:fe00:105 mdb.local'   >> /etc/hosts
echo 'fe80::200:ff:fe00:106 smb.local'   >> /etc/hosts
echo 'fe80::200:ff:fe00:107 wsa2.local'  >> /etc/hosts
echo 'fe80::200:ff:fe00:108 wsn.local'   >> /etc/hosts
echo 'fe80::200:ff:fe00:109 ovpn.local'  >> /etc/hosts
echo 'fe80::200:ff:fe00:10a bind2.local' >> /etc/hosts
echo 'fe80::200:ff:fe00:10b pc1s.local'  >> /etc/hosts

# Configure DNS resolver
echo "nameserver 2a04::4" > /etc/resolv.conf


