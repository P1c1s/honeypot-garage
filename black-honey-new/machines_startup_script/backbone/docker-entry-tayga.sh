#!/bin/bash



echo "
interface ethX
{
	AdvSendAdvert on;
	MinRtrAdvInterval 3;
	MaxRtrAdvInterval 9;
	AdvDefaultLifetime 27;
	prefix fd00:dead:beef::/48 {};
};
" >> /etc/radvd.conf

chmod o-rw /etc/radvd.conf
systemctl start radvd

echo 'TAYGA_CONF_IPV4_ADDR=172.17.0.2' | tee -a /etc/environment
echo 'TAYGA_CONF_PREFIX=2001:db8:64:ff9b::/96' | tee -a /etc/environment
echo 'TAYGA_CONF_DYNAMIC_POOL=172.17.0.128/25' | tee -a /etc/environment

source /etc/environment

# Create Tayga directories.
mkdir -p ${TAYGA_CONF_DATA_DIR} ${TAYGA_CONF_DIR}

# Configure Tayga
cat >${TAYGA_CONF_DIR}/tayga.conf <<EOF
tun-device nat64
ipv4-addr ${TAYGA_CONF_IPV4_ADDR}
prefix ${TAYGA_CONF_PREFIX}
dynamic-pool ${TAYGA_CONF_DYNAMIC_POOL}
data-dir ${TAYGA_CONF_DATA_DIR}
EOF

# Setup Tayga networking
tayga -c ${TAYGA_CONF_DIR}/tayga.conf --mktun
ip link set nat64 up

ip route add ${TAYGA_CONF_DYNAMIC_POOL} dev nat64
ip route add ${TAYGA_CONF_PREFIX} dev nat64


###########
#####LOL
###########
echo 'net.ipv6.conf.all.disable_ipv6=0' >> /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding=1' >> /etc/sysctl.conf
sysctl -p

# ip scope global filo A
ip -6 address add fd00:dead:beef::1/48 dev eth0


# Add ipv6 scope global to eth0 interface
#ip -6 address add fd00:dead:beef::100/48 dev eth1

# Add nameserver
echo 'nameserver 8.8.8.8' >> /etc/resolv.conf

# PROVA
# ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE # da dei problemi
# ip6tables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination [fd00:dead:beef::2]:80
# ip6tables -A FORWARD -d fd00:dead:beef::2 -p tcp --dport 80 -j ACCEPT



# ip6tables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination [fd00:dead:beef::2]:80
# ip6tables -A FORWARD -p tcp -d fd00:dead:beef::2 --dport 80 -j ACCEPT

# iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination [fd00:dead:beef::2]:80
# iptables -A FORWARD -p tcp -d fd00:dead:beef::2 --dport 80 -j ACCEPT


# Run Tayga
tayga -c ${TAYGA_CONF_DIR}/tayga.conf -d
