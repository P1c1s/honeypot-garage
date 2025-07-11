#!/bin/bash

echo "alias ipt='/shared/./iptables.sh'" >> /root/.bashrc
echo "nameserver 192.168.0.3" >> /etc/resolv.conf
echo "alias ip='ip -c'" >> /root/.bashrc