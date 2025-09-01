#!/bin/bash


# -----
# THE BOYS TAYGA IMAGE
# -----

set -e

# Variabili di configurazione (modifica se serve)
TAYGA_CONF_IPV4_ADDR=172.18.0.100
TAYGA_IPV6_ADDR=fd00:dead:beef::100
TAYGA_CONF_DYNAMIC_POOL=172.18.0.128/25
TAYGA_CONF_PREFIX=2001:db8:64:ff9b::/96
DOCKER_NET_NAME=test

docker stop bind9 tayga c1 || true
docker rm bind9 tayga c1 || true
docker network rm $DOCKER_NET_NAME

echo "### 1. Creo la rete Docker con subnet IPv4 e IPv6..."
sudo docker network create --subnet 172.18.0.0/16 --ipv6 --subnet=fd00:dead:beef::/48 $DOCKER_NET_NAME >/dev/null

echo "### 2. Imposto la rotta statica per Tayga (IPv4 pool via Tayga container)..."
sudo ip route add $TAYGA_CONF_DYNAMIC_POOL via $TAYGA_CONF_IPV4_ADDR

echo "### 3. Lancio il container Tayga..."
sudo docker run -d --net $DOCKER_NET_NAME --ip $TAYGA_CONF_IPV4_ADDR --ip6 $TAYGA_IPV6_ADDR --dns 8.8.8.8 \
  --name tayga --hostname tayga --privileged=true \
  --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 \
  theb0ys/tayga:latest \
  bash -c "apt update && apt install -y iproute2 curl iputils-ping tcpudump && bash"

echo "### 4. Creo la configurazione di bind9 per DNS64..."
sudo mkdir -p /etc/bind9
sudo bash -c "cat > /etc/bind9/named.conf" << EOF
options {
  directory "/var/bind";

  allow-query { any; };

  forwarders {
    2001:db8:64:ff9b::0808:0808;
  };

  auth-nxdomain no; 
  listen-on-v6 { any; };

  dns64 $TAYGA_CONF_PREFIX {
    exclude { any; };
  };
};
EOF

echo "### 5. Lancio il container bind9 per DNS64..."
sudo docker run -d --net $DOCKER_NET_NAME --privileged=true --ip6 fd00:dead:beef::200 \
  --dns fd00:dead:beef::200 --name bind9 --hostname bind9 \
  --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 \
  -v /etc/bind9/named.conf:/etc/bind/named.conf \
  resystit/bind9:latest

echo "### 6. Configuro bind9 container: rimuovo IPv4 e aggiungo rotta IPv6 per prefix sintetico..."
BIND9_IP=$(sudo docker exec bind9 ip addr list eth0 | grep "inet " | awk '{print $2}')
sudo docker exec bind9 ip addr del $BIND9_IP dev eth0
sudo docker exec bind9 ip -6 route add $TAYGA_CONF_PREFIX via $TAYGA_IPV6_ADDR

echo "### 7. Lancio il container client per testare la configurazione..."
sudo docker run -it --dns fd00:dead:beef::200 --net $DOCKER_NET_NAME --name c1 --hostname c1 \
  --privileged=true --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 ubuntu /bin/bash -c "
  apt-get update && apt-get install -y iproute2 curl iputils-ping;
  IP=\$(ip addr list eth0 | grep 'inet ' | awk '{print \$2}');
  ip addr del \$IP dev eth0;
  ip -6 route add $TAYGA_CONF_PREFIX via $TAYGA_IPV6_ADDR;
  echo 'Configurazione client pronta. Puoi testare la connettività usando curl.';
  exec bash
"

echo "### SCRIPT COMPLETATO ###"
echo "Ora sei dentro il container client (c1). Puoi provare a fare:"
echo "curl -6 -v hub.docker.com"
echo "curl -6 -v www.google.com"

