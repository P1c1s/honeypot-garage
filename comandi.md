# Samba

``` bash
apt install samba -y # server
apt install smbclient -y # client

smbclient //172.17.0.2/sharing -U pippo -c "put /pippo.txt pippo.txt"
smbclient -L //172.17.0.2/sharing -U pippo # list directies
```

# Mariadb

``` bash
apt install -y mariadb-server
nano /etc/mysql/mariadb.conf.d/50-server.cnf # bind-address = 0.0.0.0
CREATE USER 'pippo'@'ip_del_server' IDENTIFIED BY 'pippo';
CREATE USER 'pippo'@'%' IDENTIFIED BY 'pippo'; # la % dovrebbe dare accesso a tutti gli ip
GRANT ALL PRIVILEGES ON safepanda.* TO 'panda'@'ip_del_server';
FLUSH PRIVILEGES;
apt install -y phpmyadmin
nano /etc/phpmyadmin/config-db.php # $dbserver='172.17.0.3';
```

# Apache

``` bash
apt install -y apache2
apt install  -y php libapache2-mod-php php-mysql
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
