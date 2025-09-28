FROM debian:bookworm-slim

# Install OpenLDAP server e utilities
RUN apt-get update && apt-get install -y slapd ldap-utils && \
    rm -rf /var/lib/apt/lists/*

# Disabilita la configurazione automatica al primo avvio (così non fa prompt)
ENV DEBIAN_FRONTEND=noninteractive

# Copia uno script di avvio per slapd in foreground
COPY start-slapd.sh /usr/local/bin/start-slapd.sh
RUN chmod +x /usr/local/bin/start-slapd.sh

# Espone la porta LDAP standard
EXPOSE 389

# Monta volumi per dati e configurazione persistenti
VOLUME ["/etc/ldap/slapd.d", "/var/lib/ldap"]

# Comando di default: avvia slapd in foreground
CMD ["/usr/local/bin/start-slapd.sh"]

# Set timezone to Europe/Rome
RUN ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime && \
    echo "Europe/Rome" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata
