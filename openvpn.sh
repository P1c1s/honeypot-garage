#https://it.linux-console.net/?p=4041

apt update
apt install openvpn -y
cp -r /usr/share/easy-rsa /etc/openvpn/
cd /etc/openvpn/easy-rsa

echo '
export KEY_COUNTRY="INDIA"
export KEY_PROVINCE="CA"
export KEY_CITY="Junagadh"
export KEY_ORG="Howtoforge"
export KEY_EMAIL=""
export KEY_OU="OpenVPN"
' >> vars


#Genera certificato e chiave del server
./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa gen-req server nopasss
./easyrsa sign-req server server
./easyrsa gen-dh



cp ta.key /etc/openvpn/
cp pki/ca.crt /etc/openvpn/
cp pki/private/server.key /etc/openvpn/
cp pki/issued/server.crt /etc/openvpn/
cp pki/dh.pem /etc/openvpn/


#Genera certificato client e chiave
./easyrsa gen-req client nopass
./easyrsa sign-req client client


cp pki/ca.crt /etc/openvpn/client/
cp pki/issued/client.crt /etc/openvpn/client/
cp pki/private/client.key /etc/openvpn/client/



echo '
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key  # This file should be kept secret
dh dh.pem
server 10.8.0.0 255.255.255.0
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 208.67.222.222"
push "dhcp-option DNS 208.67.220.220"
keepalive 10 120
tls-auth ta.key 0 # This file is secret
cipher AES-256-CBC
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/openvpn-status.log
log         /var/log/openvpn/openvpn.log
log-append  /var/log/openvpn/openvpn.log
verb 3
explicit-exit-notify 1
' >> /etc/openvpn/server.conf

systemctl start openvpn