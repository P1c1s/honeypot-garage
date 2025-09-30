#!/bin/bash

ip address add 2a04:0:0:11::2/64 dev eth0
ip -6 route add default via 2a04:0:0:0011::1 dev eth0 # SENZA QUESTA CI SONO PROBLEMI
echo "nameserver 2a04::4" > /etc/resolv.conf
