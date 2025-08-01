docker stop tayga
docker stop bind9
docker rm tayga
docker rm bind9
docker network rm test

docker network create --subnet 172.18.0.0/16 --ipv6 --subnet=fd00:dead:beef::/48 test >/dev/null

docker run -dit --net test --ip 172.18.0.100 --ip6 fd00:dead:beef::100 --dns 8.8.8.8 \
--name tayga --hostname tayga --privileged=true --sysctl net.ipv6.conf.all.disable_ipv6=0 \
--sysctl net.ipv6.conf.all.forwarding=1 danehans/tayga:latest

docker run -dit --net test --privileged=true --ip6 fd00:dead:beef::200 \
--dns fd00:dead:beef::200 --name bind9 --hostname bind9 \
--sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 \
-v bind:/etc/bind kathara/bind:9.11
