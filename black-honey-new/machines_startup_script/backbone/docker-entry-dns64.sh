#!/bin/bash

ip address add fd00:dead:beef::200/48 dev eth0 # prima assehanzione dell'ip
ip route add 2001:db8:64:ff9b::/96 via fd00:dead:beef::1 dev eth0  metric 1024 # poi le rotte
ip route add default via fd00:dead:beef::1 dev eth0  metric 1024 

echo "fd00:dead:beef::200" >> /etc/resolv.conf

echo '
options {
  directory "/var/bind";

  allow-query { any; };

  forwarders {
    2001:db8:64:ff9b::0808:0808;
  };

  auth-nxdomain no; 
  listen-on-v6 { any; };

  dns64 2001:db8:64:ff9b::/96 {
    exclude { any; };
  };
};
' > /etc/bind/named.conf


named -c /etc/bind/named.conf -g
