#!/bin/bash
set -e  # Esci immediatamente se un comando fallisce

# Aggiungi un indirizzo IPv6
if ip -6 address show dev eth0 &>/dev/null; then
    ip -6 address add 2a04::2/64 dev eth0
else
    echo "Interfaccia eth0 non trovata."
    exit 1
fi

# Configura il nameserver
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# Aggiorna il sistema
apt update
apt upgrade -y

# Installa OpenVPN e Easy-RSA
apt install openvpn easy-rsa -y

# Crea la directory per Easy-RSA
make-cadir ~/openvpn-ca
cd ~/openvpn-ca

# Configura le variabili di Easy-RSA
cat <<EOL > vars
export KEY_COUNTRY="IT"
export KEY_PROVINCE="RM"
export KEY_CITY="Roma"
export KEY_ORG="The Boys"
export KEY_EMAIL="agency@theboys.it"
export KEY_OU="The Boys Unit"
EOL

# Carica le variabili
source vars

# Pulisci eventuali chiavi precedenti
yes | ./easyrsa clean-all

# Crea l'autorità di certificazione (CA)
yes | ./easyrsa init-pki
yes | ./easyrsa build-ca nopass

# Crea la chiave del server
yes | ./easyrsa gen-req server nopass
yes | ./easyrsa sign-req server server

# Crea il certificato Diffie-Hellman
yes | ./easyrsa gen-dh

# (Opzionale) Crea un certificato per il client
yes | ./easyrsa gen-req client1 nopass
yes | ./easyrsa sign-req client client1

# (Opzionale) Crea il file di configurazione del server
if [ -f /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz ]; then
    cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz /etc/openvpn/
    gunzip /etc/openvpn/server.conf.gz
else
    echo "File di configurazione del server non trovato. Creare manualmente."
    exit 1
fi

# Modifica il file di configurazione del server
sed -i "s|ca ca.crt|ca /root/openvpn-ca/pki/ca.crt|g" /etc/openvpn/server.conf
sed -i "s|cert server.crt|cert /root/openvpn-ca/pki/issued/server.crt|g" /etc/openvpn/server.conf
sed -i "s|key server.key|key /root/openvpn-ca/pki/private/server.key|g" /etc/openvpn/server.conf
sed -i "s|dh dh2048.pem|dh /root/openvpn-ca/pki/dh.pem|g" /etc/openvpn/server.conf

# Avvia il servizio OpenVPN
systemctl start openvpn@server
systemctl enable openvpn@server

echo "OpenVPN è stato configurato e avviato con successo!"
