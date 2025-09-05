#!/bin/bash

# ip scope global filo A
ip -6 address add fd00:dead:beef::2/48 dev eth0
ip -6 route add default via fd00:dead:beef::1 dev eth0

# DNS64
ip -6 route add 2001:db8:64:ff9b::/96 via fd00:dead:beef::1
echo 'nameserver fd00:dead:beef::200' >> /etc/resolv.conf