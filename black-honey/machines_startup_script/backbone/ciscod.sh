#!/bin/bash

# Assign a global IPv6 address to eth3
ip address add 2a04:0:0:11::1/64 dev eth3

# Remove read/write permissions for others from radvd.conf DA RIVEDERE PER OGNI ROUTER
chmod o-rw /etc/radvd.conf

# Add IPv6 routes to specific subnets via link-local addresses of neighbor routers
ip -6 route add 2a04:0:0:0010::/64 via fe80::b4:91ff:fec2:9a50 dev eth1   # Route for subnet 10
ip -6 route add 2a04:0:0:0012::/64 via fe80::c6:d1ff:fe83:c73e dev eth2   # Route for subnet 12

# # Add a default IPv6 route via link-local address (VLAN)
# ip -6 route add default via fe80::b4:91ff:fec2:9a50 dev eth0

# Create a new user 'sirouter' with home directory and password '2Password!'
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '2Password!') sirouter

# Set IPv6 nameserver
echo "nameserver 2a04::4" > /etc/resolv.conf

# Start the radvd service
systemctl start radvd

# Start SSH service
systemctl start ssh

# Optional: remove loopback address (usually unnecessary)
# ip address del 127.0.0.1/8 dev lo
# or
# ip address del 127.0.0.1 dev lo
