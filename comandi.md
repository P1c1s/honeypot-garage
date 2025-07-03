# Samba
## Server
``` bash
apt install samba -y # server
service smbd start #start service

#aggiunta utenti
adduser pippo
smbpasswd -a pippo

mkdir /home/pippo/sharing
chmod 777 /home/pippo/sharing

#test funzionamento samba -- stampa parametri configurazione
testparm
```

# Client

``` bash
apt install smbclient -y # client
smbclient //172.17.0.2/sharing -U pippo -c "put /pippo.txt pippo.txt"
smbclient -L //172.17.0.2/sharing -U pippo # list directies
```

# Mariadb

``` bash
apt install -y mariadb-server
nano /etc/mysql/mariadb.conf.d/50-server.cnf # bind-address = 0.0.0.0
#CREATE USER 'pippo'@'ip_del_server' IDENTIFIED BY 'pippo';
CREATE USER 'pippo'@'%' IDENTIFIED BY 'pippo'; # la % dovrebbe dare accesso a tutti gli ip
GRANT ALL PRIVILEGES ON safepanda.* TO 'panda'@'%';
FLUSH PRIVILEGES;

```

# Apache

``` bash
apt install -y apache2
apt install  -y php libapache2-mod-php php-mysql
#comunicazione con MariaDB
apt install -y phpmyadmin
nano /etc/phpmyadmin/config-db.php # $dbserver='172.17.0.3';
```

# MongoDb

``` bash
apt-get install -y gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc
gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] http://repo.mongodb.org/apt/debian bookworm/mongodb-org/8.0 main" | tee  /etc/apt/sources.list.d/mongodb-org-8.0.list
apt-get update
apt-get install -y mongodb-org

```

# Syslog

``` bash
sudo apt-get update
sudo apt-get install rsyslog
``` 

# Netcat

``` bash
nc -l -p <porta server> # server
nc <ip server> <porta server> # client
``` 

# OpenLdap

``` bash

```

# OpenVpn

``` bash
# porta 1194 (udp), 943 (per interfaccia web), (443 per tcp)
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh

Password openvpn-as LlZEnyA9HRyF

```

# Regole di iptables:
```bash
# per port forwarding del router cisco
iptables -t nat -A PREROUTING -i eth4 -p tcp --dport 80 -j DNAT --to-destination 192.169.0.3:80
iptables -A FORWARD -p tcp -d 192.169.0.3 --dport 80 -j ACCEPT

# 172.17.0.2 è il container di docker con openvpn, wlo1 è l'interfaccia della scheda di rete del computer
sudo iptables -t nat -A PREROUTING -i wlo1 -p tcp --dport 943 -j DNAT --to-destination 172.17.0.2:943
sudo iptables -A FORWARD -p tcp -d 172.17.0.2 --dport 943 -j ACCEPT
```
