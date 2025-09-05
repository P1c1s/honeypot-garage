import os
import random
import ipaddress
import hashlib


def get_image_for_host(structure, value):
    for key, values in structure.items():
        if value in values:
            return key
    return None  # oppure: raise ValueError(f"{value} non trovato")


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


def find_router_connected_to_plan(plan_name, rete, current_router):
    for router_name, router_data in rete.items():
        if router_name != current_router and plan_name in router_data.get("plan", []):
            return router_name
    return None  # Se non trovato


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


def copy_folder_to_machine(machine, src_dir, dst_dir):
    for root, _, files in os.walk(src_dir):
        for filename in files:
            local_path = os.path.join(root, filename)
            relative_path = os.path.relpath(local_path, src_dir)
            remote_path = os.path.join(dst_dir, relative_path)

            # Determina se il file è un file di testo o binario
            if filename.endswith(('.png', '.ico', '.jpg', '.jpeg')):  # Aggiungi altre estensioni di file di testo se necessario
                with open(local_path, "rb") as f:
                    content = f.read()
                machine.create_file_from_string(content=content.decode('latin-1'), dst_path=remote_path)  # Decodifica in modo sicuro
            else:
                with open(local_path, "r") as f:
                    content = f.read()
                machine.create_file_from_string(content=content, dst_path=remote_path)


def genera_mac_progressivi(penultimo_gruppo: str):
    """
    Genera MAC address da 00:00:00:00:<penultimo>:01 a 00:00:00:00:<penultimo>:0b
    """
    penultimo_gruppo = penultimo_gruppo.replace("M", "")
    macs = []
    for ultimo in range(0x01, 0x0F):  # da 1 a 16
        mac = f"00:00:00:00:{penultimo_gruppo.zfill(2)}:{ultimo:02x}"
        macs.append(mac)
    return macs