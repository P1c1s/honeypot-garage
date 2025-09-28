#!/bin/bash

# Add an IPv6 address to the network interface eth1
ip address add 2a04::4/64 dev eth1

# Set the default IPv6 gateway via 2a04:0:0:0::1 on interface eth1
ip -6 route add default via 2a04:0:0:0000::1 dev eth1

# Create a new user named 'siserver' and password '1Password!' encrypted with crypt()
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '1Password!') siserver

# Configure the DNS resolver, setting an IPv6 nameserver
echo "nameserver ::1" > /etc/resolv.conf

# Start the SSH service
systemctl start ssh

# Start the BIND9 DNS server
systemctl start bind9
