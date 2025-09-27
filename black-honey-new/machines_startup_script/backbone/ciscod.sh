#!/bin/bash

# Assign a global IPv6 address to eth3
ip address add 2a04:0:0:11::1/64 dev eth3

# Set IPv6 nameserver
echo "nameserver 2a04::4" > /etc/resolv.conf

# Remove read/write permissions for others from radvd.conf DA RIVEDERE PER OGNI ROUTER
chmod o-rw /etc/radvd.conf

# Start the radvd service
systemctl start radvd

# Create a new user 'sirouter' with home directory and password '2Password!'
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '2Password!') sysrouter

# Append the rule that defines ListenAddress only on eth0
echo "ListenAddress fe80::200:ff:fe00:208%eth0" >> /etc/ssh/sshd_config

# Start SSH service
systemctl start ssh