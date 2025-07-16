# import ipaddress

# net = ipaddress.ip_network('192.168.0.0/24')
# ip = list(net.hosts())[0] 
# print(ip)
# print(ip+1)

def get_image_for_host(structure, value):
    for key, values in structure.items():
        if value in values:
            return key
    return None  # oppure: raise ValueError(f"{value} non trovato")

import random

def generate_mac():
    mac = [0x02] + [random.randint(0x00, 0xff) for _ in range(5)]
    return ':'.join(f"{x:02x}" for x in mac)

import ipaddress


import ipaddress

def mac_to_ipv6_link_local(mac: str) -> str:
    if not mac:
        raise ValueError("MAC address is None")

    # Rimuovi separatori e rendi tutto maiuscolo
    mac = mac.replace(":", "").replace("-", "").upper()
    if len(mac) != 12:
        raise ValueError(f"MAC address '{mac}' non valido")

    # Dividi in blocchi da 2 caratteri
    mac_bytes = [mac[i:i+2] for i in range(0, 12, 2)]

    # Inverti il 7° bit (Universal/Local bit) del primo byte
    first_byte = int(mac_bytes[0], 16)
    first_byte ^= 0x02
    mac_bytes[0] = f"{first_byte:02x}"

    # Inserisci 'fffe' nel mezzo per ottenere EUI-64
    eui64 = mac_bytes[:3] + ['ff', 'fe'] + mac_bytes[3:]
    eui64_str = ''.join(eui64)

    # Inserisci i due punti ogni 4 cifre
    ipv6_suffix = ':'.join([eui64_str[i:i+4] for i in range(0, len(eui64_str), 4)])

    # Costruisci indirizzo link-local IPv6
    ipv6_link_local = f"fe80::{ipv6_suffix}"
    return str(ipaddress.IPv6Address(ipv6_link_local))



def find_router_connected_to_plan(plan_name, rete, current_router):
    for router_name, router_data in rete.items():
        if router_name != current_router and plan_name in router_data.get("plan", []):
            return router_name
    return None  # Se non trovato

import hashlib

def generate_mac_from_router_iface(router_name: str, iface_index: int) -> str:
    """
    Genera un MAC address deterministico (ma valido) dato un nome router e un indice interfaccia.
    L'output sarà nel formato standard 'XX:XX:XX:XX:XX:XX'.
    """
    # Usa hash del nome del router + indice per generare 6 byte
    base_string = f"{router_name}-{iface_index}"
    hash_bytes = hashlib.sha256(base_string.encode()).digest()

    # Prendi i primi 6 byte e forza i primi bit per ottenere un MAC "locally administered"
    mac_bytes = bytearray(hash_bytes[:6])
    mac_bytes[0] = (mac_bytes[0] & 0b11111110) | 0b00000010  # clear multicast bit, set local bit

    # Formatta in stringa MAC
    mac = ':'.join(f"{b:02x}" for b in mac_bytes)
    return mac
