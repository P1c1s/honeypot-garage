#!/bin/bash

# Test the main rsyslog configuration file
rsyslogd -N1 -f /etc/rsyslog.conf

# Test an additional rsyslog configuration for forwarding logs
rsyslogd -N1 -f /etc/rsyslog.d/20-forward-logs.conf

# Start the rsyslog service
systemctl start rsyslog

# Append the rule that defines ListenAddress only on eth0
echo "ListenAddress fe80::200:ff:fe00:109%eth0" >> /etc/ssh/sshd_config

# Start the SSH service
systemctl start ssh
