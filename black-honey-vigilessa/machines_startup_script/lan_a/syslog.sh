#!/bin/bash

# Add an IPv6 address to the network interface eth1
ip address add 2a04::3/64 dev eth1

# Set the default IPv6 gateway via 2a04:0:0:0::1 on interface eth1
ip -6 route add default via 2a04:0:0:0000::1 dev eth1

# Create a new user named 'syserver' and password '1Password!' encrypted with crypt()
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '1Password!') syserver

# Set the DNS resolver to IPv6 nameserver 2a04::4
echo "nameserver 2a04::4" > /etc/resolv.conf

# Test the rsyslog configuration in /etc/rsyslog.conf
rsyslogd -N1 -f /etc/rsyslog.conf

# Test the rsyslog configuration in /etc/rsyslog.d/50-remote-logs.conf
rsyslogd -N1 -f /etc/rsyslog.d/50-remote-logs.conf

# Restart the rsyslog service
systemctl restart rsyslog

# Append the rule that defines ListenAddress only on eth0
echo "ListenAddress fe80::200:ff:fe00:102%eth0" >> /etc/ssh/sshd_config

# Start the SSH service
systemctl start ssh