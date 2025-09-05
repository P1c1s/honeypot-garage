# Usa l'immagine di base di Tayga
FROM danehans/tayga:latest

# Imposta variabili di ambiente
ENV TAYGA_CONF_IPV4_ADDR=172.18.0.100
ENV TAYGA_IPV6_ADDR=fd00:dead:beef::100
ENV TAYGA_CONF_DYNAMIC_POOL=172.18.0.128/25
ENV TAYGA_CONF_PREFIX=2001:db8:64:ff9b::/96

# Abilita IPv6 e forwarding
RUN sysctl -w net.ipv6.conf.all.disable_ipv6=0 && \
    sysctl -w net.ipv6.conf.all.forwarding=1

# Aggiorna e installa pacchetti utili
RUN apt-get update && \
    apt-get install -y iproute2 curl iputils-ping tcpdump nano netcat-opnebsd traceroute net-tools && \
    rm -rf /var/lib/apt/lists/*

# Imposta hostname
ENV HOSTNAME=tayga

COPY .bashrc /root/.bashrc

# Comando di default all'avvio del container
CMD ["bash"]
