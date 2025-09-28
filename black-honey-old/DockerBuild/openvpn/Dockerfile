# Usa l'ultima versione stabile di Debian
FROM debian:latest

# Mantieni l'immagine più leggera e non interattiva
# ENV DEBIAN_FRONTEND=noninteractive

# Aggiorna pacchetti e installa OpenVPN e utilità di base
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openvpn \
        easy-rsa \
        iproute2 \
        iptables \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Crea una directory di lavoro per i file di configurazione
WORKDIR /etc/openvpn

# (Opzionale) Copia qui i tuoi file di configurazione, se li hai già
COPY ./server.conf /etc/openvpn/server.conf
COPY ca.crt /etc/openvpn/ca.crt
COPY server.crt /etc/openvpn/server.crt
COPY server.key /etc/openvpn/server.key
COPY dh.pem /etc/openvpn/dh.pem

# COPY ./pki /etc/openvpn/pki

# Espone la porta UDP di default per OpenVPN
EXPOSE 1194/udp

# Avvia OpenVPN con la configurazione server (puoi cambiare nome file)
CMD ["openvpn", "--config", "/etc/openvpn/server.conf"]

COPY .bashrc /root/.bashrc
