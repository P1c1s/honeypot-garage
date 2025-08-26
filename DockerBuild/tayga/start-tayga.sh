#!/bin/bash
set -e

: "${TAYGA_IPV4_ADDR:=192.0.2.1}"
: "${TAYGA_PREFIX:=64:ff9b::/96}"
: "${TAYGA_POOL:=192.0.2.0/24}"

# Genera il conf definitivo usando delimitatore | per evitare conflitti con slash
sed -e "s|{{IPv4_ADDR}}|${TAYGA_IPV4_ADDR}|" \
    -e "s|{{PREFIX}}|${TAYGA_PREFIX}|" \
    -e "s|{{POOL}}|${TAYGA_POOL}|" \
    /etc/tayga.conf.template > /etc/tayga.conf

# Abilita forwarding: prova con sysctl, altrimenti fallback diretto
if command -v sysctl >/dev/null 2>&1; then
  sysctl -w net.ipv4.ip_forward=1
  sysctl -w net.ipv6.conf.all.forwarding=1
else
  echo 1 > /proc/sys/net/ipv4/ip_forward
  echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
fi

cleanup() {
  ip link del nat64 2>/dev/null || true
  ip -4 route del "${TAYGA_POOL}" 2>/dev/null || true
  pkill tayga 2>/dev/null || true
}

cleanup

exec tayga --config /etc/tayga.conf
