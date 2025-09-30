#!/bin/bash

# Create a new Linux bridge called 'mainbridge'
ip link add name mainbridge type bridge

# Attach interfaces to the bridge
ip link set dev eth1 master mainbridge   # Interface connected to cisco
ip link set dev eth2 master mainbridge   # Interface connected to wsa2
ip link set dev eth3 master mainbridge   # Interface connected to wsn
ip link set dev eth4 master mainbridge   # Interface connected to ovpn
ip link set dev eth5 master mainbridge   # Interface connected to bind2

# Bring the bridge interface up
ip link set up dev mainbridge

# Set the MAC address ageing time for the bridge to 600 seconds
brctl setageing mainbridge 600

# Create a new user 'sysrouter' and password '2Password!' hashed with Perl 'crypt'
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '2Password!') sysrouter

# Start the SSH service
systemctl start ssh
