#!/bin/bash

# Assign an IPv6 address to interface eth0
ip address add 2a04:0:0:1::4/64 dev eth1

# Add a default IPv6 route via the gateway
ip -6 route add default via 2a04:0:0:0001::1 dev eth1

# Create a new user 'siserver' with a home directory and password '1Password!' hashed
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '1Password!') siserver

# Set DNS resolver to IPv6 nameserver
echo "nameserver 2a04::4" > /etc/resolv.conf

# This will create a user 'pippo' with an *invalid* password hash
useradd -m -p pippo pippo

# Add 'pippo' as a Samba user
smbpasswd -a pippo

# Start the Samba daemon
systemctl start smbd

# Start the SSH service
systemctl start ssh
