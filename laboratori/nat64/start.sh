docker stop cisco
docker stop pc1
docker rm cisco
docker rm pc1
docker network rm my_ipv6_network

# Crea la rete IPv6
docker network create \
  --ipv6 \
  --subnet=2001:0:0:0::/64 \
  my_ipv6_network

# Avvia i container senza connessione alla rete bridge, utilizzando solo la rete personalizzata
docker run -dit --name cisco --net my_ipv6_network --ip6 2001:0:0:0::3 --hostname cisco --privileged=True theb0ys/base
docker run -dit --name pc1 --ip6 2001:0:0:0::4  --net my_ipv6_network --hostname pc theb0ys/base

# Se necessario, collega 'cisco' alla rete bridge per ulteriori operazioni
#docker network connect bridge cisco
#docker network connect my_ipv6_network cisco

