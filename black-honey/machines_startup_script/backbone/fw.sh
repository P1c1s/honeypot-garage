#!/bin/bash

# # Add IPv6 routes to specific subnets via link-local addresses of neighbor routers
# ip -6 route add 2a04:0:0:0::/60 via fe80::fb:b6ff:fe50:813d dev eth1   # Route for subnet 0-10
# ip -6 route add 2a04:0:0:10::/60 via fe80::ee:42ff:fe6a:e18 dev eth2   # Route for subnet 10-ff

# ip for W
ip -6 address add fd00:dead:beef::2/48 dev eth3
ip -6 route add default via fd00:dead:beef::1 dev eth3

# DNS64
ip -6 route add 2001:db8:64:ff9b::/96 via fd00:dead:beef::1
echo 'nameserver fd00:dead:beef::200' >> /etc/resolv.conf

# ip -6 route add default via fe80::a6:54ff:fe5c:af71 dev eth2
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '2Password!') sirouter
systemctl start ssh
