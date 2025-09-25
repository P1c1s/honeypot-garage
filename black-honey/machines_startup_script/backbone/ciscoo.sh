
#!/bin/bash

# Assign a global IPv6 address to eth0
ip address add 2a04:0:0:12::1/64 dev eth3

# Remove read/write permissions for others from radvd.conf
chmod o-rw /etc/radvd.conf

# Start the radvd service
systemctl start radvd

# # Add IPv6 routes to specific subnets via link-local addresses of neighbor routers
# ip -6 route add 2a04:0:0:0011::/64 via fe80::b4:91ff:fec2:9a50 dev eth1   # Route for subnet 10
# ip -6 route add 2a04:0:0:0010::/64 via fe80::c6:d1ff:fe83:c73e dev eth2   # Route for subnet 12

# # Add a default IPv6 route via the router at fe80::c6:23ff:fecf:3f92
# ip -6 route add default via fe80::c6:23ff:fecf:3f92 dev eth2

# Create a new user 'sirouter' and password = '1Password!' (hashed using Perl crypt)
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '2Password!') sirouter

# Start the SSH service
systemctl start ssh

# Set the IPv6 nameserver
echo "nameserver 2a04::4" > /etc/resolv.conf
