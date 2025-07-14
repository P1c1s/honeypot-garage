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

import random

def generate_mac():
    mac = [0x02] + [random.randint(0x00, 0xff) for _ in range(5)]
    return ':'.join(f"{x:02x}" for x in mac)

