#!/bin/bash

# Assign a global IPv6 address
ip address add 2a04:0:0:0::1/64 dev eth2
ip address add 2a04:0:0:1::1/64 dev eth3
ip address add 2a04:0:0:2::1/64 dev eth4

# Set IPv6 nameserver
echo "nameserver 2a04::4" > /etc/resolv.conf

# Remove read/write permissions for others from radvd.conf DA RIVEDERE PER OGNI ROUTER
chmod o-rw /etc/radvd.conf

# Start the radvd service
systemctl start radvd

# Create a new user 'sirouter' with home directory and password '2Password!'
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '2Password!') sysrouter

# Append the rule that defines ListenAddress only on eth0
echo "ListenAddress fe80::200:ff:fe00:202%eth0" >> /etc/ssh/sshd_config

# Start SSH service
systemctl start ssh




### iptbales rules

# ip6tables -F

# # Policy di default: blocca tutto in ingresso e forward, consenti output
# ip6tables -P INPUT DROP
# ip6tables -P FORWARD ACCEPT
# ip6tables -P OUTPUT ACCEPT

# # Loopback (necessario per servizi locali)
# ip6tables -A INPUT -i lo -j ACCEPT -m comment --comment "Allow loopback input"
# ip6tables -A OUTPUT -o lo -j ACCEPT -m comment --comment "Allow loopback output"

# # Mantieni connessioni già stabilite
# ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT -m comment --comment "Allow established/related input"
# ip6tables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT -m comment --comment "Allow established/related forward"

# # Prima, blocca tutto il traffico verso WSA1
# ip6tables -A INPUT -d 2a04:0:0:1::2 -j DROP -m comment --comment "Drop all traffic to WSA1 by default"

# # Poi, consenti solo da 2a04:0:0:10::760
# ip6tables -I INPUT -s 2a04:0:0:10::760 -d 2a04:0:0:1::2 -j ACCEPT -m comment --comment "Allow only 2a04:0:0:10::760 to access WSA1"

# # ICMPv6 (ping, ND, RA) indispensabile per IPv6
# ip6tables -A INPUT -p icmpv6 -j ACCEPT -m comment --comment "Allow ICMPv6 input"
# ip6tables -A FORWARD -p icmpv6 -j ACCEPT -m comment --comment "Allow ICMPv6 forward"

# # Permetti solo traffico verso 2a04::4
# ip6tables -A INPUT -d 2a04::4 -j ACCEPT -m comment --comment "Allow input traffic destined to 2a04::4"
# ip6tables -A FORWARD -d 2a04::4 -j ACCEPT -m comment --comment "Allow forward traffic destined to 2a04::4"

# ip6tables -A INPUT -p tcp --dport 80 -s 2a04:0:0:10::/60 -d 2a04:0:0:1::2 -j ACCEPT -m comment --comment "Allow input traffic destined wsa1 from lan D"

# # Log di default
# ip6tables -A INPUT -j LOG --log-prefix "DROP INPUT: " --log-level 4 -m comment --comment "Log dropped INPUT packets"
# ip6tables -A FORWARD -j LOG --log-prefix "DROP FORWARD: " --log-level 4 -m comment --comment "Log dropped FORWARD packets"


