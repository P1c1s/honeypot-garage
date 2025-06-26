#!/bin/bash

#
echo 'alias ip="ip -c"' >> /root/.bashrc
echo 'alias ipt="/shared/./iptables.sh"' >> /root/.bashrc

#hosts
echo "200.0.0.9 cisco" >> /etc/hosts
echo "192.168.178.1 fritzbox" >> /etc/hosts
echo "192.168.0.1 timhub" >> /etc/hosts
echo "192.168.2.254 zyxel" >> /etc/hosts
echo "192.168.179.100 webserver" >> /etc/hosts
echo "192.168.179.101 sshserver" >> /etc/hosts
echo "192.168.179.102 xxxserver" >> /etc/hosts
echo "192.168.178.10 macbookpro" >> /etc/hosts
echo "192.168.178.11 thinkpad" >> /etc/hosts
echo "192.168.0.45 mbp" >> /etc/hosts
echo "192.168.0.110 windows" >> /etc/hosts
echo "192.168.2.2 macbokair" >> /etc/hosts
echo "192.168.2.3 dell" >> /etc/hosts