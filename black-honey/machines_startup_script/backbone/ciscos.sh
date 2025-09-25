#!/bin/bash

ip address add 2a04:0:0:10::1/64 dev eth3
chmod o-rw /etc/radvd.conf
systemctl start radvd
ip -6 route add 2a04:0:0:0010::/64 via fe80::b4:91ff:fec2:9a50 dev eth1
ip -6 route add 2a04:0:0:0012::/64 via fe80::c6:d1ff:fe83:c73e dev eth2
ip -6 route add default via fe80::b4:91ff:fec2:9a50 dev eth1
perl -e 'print crypt($ARGV[0], "password")' '2Password!'
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '1Password!') siserver
systemctl start ssh
echo "nameserver 2a04::4" > /etc/resolv.conf
