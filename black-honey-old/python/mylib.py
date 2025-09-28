import ipaddress
import random

def generate_mac():
    mac = [0x02] + [random.randint(0x00, 0xff) for _ in range(5)]
    return ':'.join(f"{x:02x}" for x in mac)

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

machine_startup = {}

def append_startup(machine_name, command):
    if machine_name not in machine_startup:
        machine_startup[machine_name] = []
    
    machine_startup[machine_name].append(command)
