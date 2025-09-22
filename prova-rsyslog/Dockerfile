# File: Dockerfile
FROM kathara/base:latest

# Aggiorna i pacchetti e installa Apache, rsyslog, nginx e samba
RUN apt-get update && \
    apt-get install -y apache2 rsyslog nginx samba && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Espone alcune porte utili (modifica secondo necessità)
EXPOSE 80 443 514 445 139

# Avvia un semplice init che tiene in vita il container
CMD ["/bin/bash", "-c", "service rsyslog start && service apache2 start && service nginx start && service smbd start && tail -f /dev/null"]
