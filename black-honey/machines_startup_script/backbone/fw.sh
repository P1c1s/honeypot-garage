#!/bin/bash

# # # Add IPv6 routes to specific subnets via link-local addresses of neighbor routers
# # ip -6 route add 2a04:0:0:0::/60 via fe80::fb:b6ff:fe50:813d dev eth1   # Route for subnet 0-10
# # ip -6 route add 2a04:0:0:10::/60 via fe80::ee:42ff:fe6a:e18 dev eth2   # Route for subnet 10-ff

# # Assign a global IPv6 address to eth3
# ip -6 address add fd00:dead:beef::2/48 dev eth3

# # Define a route via nat64
# ip -6 route add default via fd00:dead:beef::1 dev eth3

# # DNS64
# ip -6 route add 2001:db8:64:ff9b::/96 via fd00:dead:beef::1
# echo 'nameserver fd00:dead:beef::200' >> /etc/resolv.conf

# # Create a new user 'sirouter' and password = '1Password!' (hashed using Perl crypt)
# useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '2Password!') sysrouter

# # Append the rule that defines ListenAddress only on eth0
# cat "ListenAddress fe80::200:ff:fe00:206%eth0" >> /etc/ssh/sshd_config

# # Start the SSH service
# systemctl start ssh



#!/bin/bash

# Assign a global IPv6 address to eth0
ip address add 2a04:0:0:10::1/64 dev eth3

# Set the IPv6 nameserver
echo "nameserver 2a04::4" > /etc/resolv.conf

# Create a new user 'sirouter' and password = '1Password!' (hashed using Perl crypt)
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '2Password!') sysrouter

# Append the rule that defines ListenAddress only on eth0
echo "ListenAddress fe80::200:ff:fe00:201%eth0" >> /etc/ssh/sshd_config

# Start the SSH service
systemctl start ssh

