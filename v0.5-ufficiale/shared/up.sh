#!/bin/bash

# echo "192.171.0.2 pc1" >> /etc/hosts
# echo "192.169.0.2 mdb" >> /etc/hosts
# echo "192.169.0.3 ws1a" >> /etc/hosts
# echo "192.169.0.4 smb" >> /etc/hosts
# echo "192.168.0.2 sshserver" >> /etc/hosts
#echo "alias ipt='/shared/./iptables.sh'" >> /root/.bashrc
echo "nameserver 192.168.0.3" >> /etc/resolv.conf
echo "alias ip='ip -c'" >> /root/.bashrc