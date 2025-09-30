#!/bin/bash

# Assign an IPv6 address to interface eth1
ip address add 2a04:0:0:10::3/64 dev eth1

# Add a default IPv6 route via the gateway
ip -6 route add default via 2a04:0:0:0010::1 dev eth1

# Add static hostname mappings for local services
echo 'fe80::200:ff:fe00:201 fw.local' > /etc/hosts
echo 'fe80::200:ff:fe00:202 cisco.local' >> /etc/hosts
echo 'fe80::200:ff:fe00:203 switcha.local' >> /etc/hosts
echo 'fe80::200:ff:fe00:204 switchb.local' >> /etc/hosts
echo 'fe80::200:ff:fe00:205 switchc.local' >> /etc/hosts
echo 'fe80::200:ff:fe00:206 ciscos.local' >> /etc/hosts
echo 'fe80::200:ff:fe00:207 switchs.local' >> /etc/hosts
echo 'fe80::200:ff:fe00:208 ciscod.local' >> /etc/hosts
echo 'fe80::200:ff:fe00:209 switchd.local' >> /etc/hosts
echo 'fe80::200:ff:fe00:20a ciscoo.local' >> /etc/hosts
echo 'fe80::200:ff:fe00:20b switcho.local' >> /etc/hosts
echo 'fe80::200:ff:fe00:20c pc2s.local' >> /etc/hosts

# Configure DNS resolver
echo "nameserver 2a04::4" > /etc/resolv.conf



