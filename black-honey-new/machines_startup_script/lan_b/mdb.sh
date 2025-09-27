#!/bin/bash

# Add an IPv6 address to the network interface eth1
ip address add 2a04:0:0:1::3/64 dev eth1

# Set the default IPv6 gateway via 2a04:0:0:1::1 on interface eth1
ip -6 route add default via 2a04:0:0:0001::1 dev eth1

# Generate a hashed password for '1Password!' (prints hash to screen)
perl -e 'print crypt($ARGV[0], "password")' '1Password!'

# Create a new user 'siserver' with a home directory and password '1Password!' hashed
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '1Password!') siserver

# Set the DNS resolver to IPv6 nameserver 2a04::4
echo "nameserver 2a04::4" > /etc/resolv.conf

# Start the MariaDB service
service mariadb start

# Import SQL commands from /root/import.sql into MySQL after start MariaDB server
mysql < /root/import.sql && rm /root/import.sql

# Start the SSH service
systemctl start ssh


