
#!/bin/bash

# Assign a global IPv6 address to eth3
ip address add 2a04:0:0:12::1/64 dev eth3

# Set the IPv6 nameserver
echo "nameserver 2a04::4" > /etc/resolv.conf

# Remove read/write permissions for others from radvd.conf
chmod o-rw /etc/radvd.conf

# Start the radvd service
systemctl start radvd

# Create a new user 'sirouter' and password = '1Password!' (hashed using Perl crypt)
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '2Password!') sysrouter

# Append the rule that defines ListenAddress only on eth0
echo "ListenAddress fe80::200:ff:fe00:20a%eth0" >> /etc/ssh/sshd_config

# Start the SSH service
systemctl start ssh

