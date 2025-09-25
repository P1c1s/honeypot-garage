#!/bin/bash

# Add an IPv6 address to the network interface eth0
ip address add 2a04:0:0:1::2/64 dev eth1

# Set the default IPv6 gateway via 2a04:0:0:1::1 on interface eth0
ip -6 route add default via 2a04:0:0:0001::1 dev eth1

# Create a new user 'siserver' with a home directory and hashed password '1Password!'
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '1Password!') siserver

# Set the DNS resolver to IPv6 nameserver 2a04::4
echo "nameserver 2a04::4" > /etc/resolv.conf

# Test the main rsyslog configuration file
rsyslogd -N1 -f /etc/rsyslog.conf

# Test an additional rsyslog configuration for forwarding logs
rsyslogd -N1 -f /etc/rsyslog.d/20-forward-logs.conf

# Restart the rsyslog service
systemctl restart rsyslog

# Start the Apache2 web server
systemctl start apache2

# Start the SSH service
systemctl start ssh

