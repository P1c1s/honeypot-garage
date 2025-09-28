ip -6 address add 2a04::2/64 dev eth0

echo "nameserver 8.8.8.8" > /etc/resolv.conf

apt update
apt upgrade -y

apt install openvpn easy-rsa -y

make-cadir ~/openvpn-ca

echo '
export KEY_COUNTRY="IT"
export KEY_PROVINCE="RM"
export KEY_CITY="Roma"
export KEY_ORG="The Boys"
export KEY_EMAIL="agency@theboys.it"
export KEY_OU="The Boys Unit"
' >> ~/openvpn-ca/vars

source ~/openvpn-ca/vars

# Pulisci eventuali chiavi precedenti
./easyrsa clean-all

# Crea l'autorità di certificazione (CA)
./easyrsa init-pki
./easyrsa build-ca

# Crea la chiave del server
./easyrsa gen-req server nopass
./easyrsa sign-req server server

# Crea il certificato Diffie-Hellman
./easyrsa gen-dh


