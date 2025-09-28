#!/bin/bash

# Create a new Linux bridge called "mainbridge"
ip link add name mainbridge type bridge

# Attach interfaces to the bridge
ip link set dev eth1 master mainbridge   # Interface connected to cisco-o
ip link set dev eth2 master mainbridge   # Interface connected to pc1o

# Bring the bridge interface up
ip link set up dev mainbridge

# Set bridge MAC address aging time to 600 seconds
brctl setageing mainbridge 600

# Create a new user 'sirouter' with home directory and password '2Password!'
useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' '2Password!') sirouter

# Start the SSH service
systemctl start ssh
