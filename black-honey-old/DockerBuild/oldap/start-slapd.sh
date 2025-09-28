#!/bin/bash
# Avvia slapd in foreground (debug livello 0) con interfacce LDAP e LDAPI

exec /usr/sbin/slapd -h "ldap:/// ldapi:///" -u openldap -g openldap -d 0
# Pulisci la vecchia config (se c'è)
rm -rf /etc/ldap/slapd.d/*
rm -rf /var/lib/ldap/*

# Importa la config
slapadd -F /etc/ldap/slapd.d -l init.ldif

# Cambia ownership a openldap
chown -R openldap:openldap /etc/ldap/slapd.d /var/lib/ldap

# Avvia slapd in foreground
slapd -h "ldap:/// ldapi:///" -u openldap -g openldap -d 0
