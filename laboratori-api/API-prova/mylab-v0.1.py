from Kathara.manager.Kathara import Kathara
from Kathara.model.Lab import Lab
from Kathara.model.Link import Link
import ipaddress
from modules.mylib import *

lab = Lab("Prova")

network_host = {
    "A" : ["oldap", "bind1"],
    "B" : ["mdb", "wsa1", "smb"],
    "C" : ["nginx", "wsa2", "ovpn", "bind2"]
}

image_host = {
    "theb0ys/apache": ["wsa1", "wsa2"],
    "theb0ys/base": ["bind1", "bind2", "nginx", "ovpn"],
    "theb0ys/mariadb": ["mdb"],
    "theb0ys/samba": ["smb"],
}

network_address = {
    "A" : "192.168.23.0/24",
    "B" : "192.168.24.0/24",
    "C" : "192.168.25.0/24"
}

network_router = {
    "A" : ["cisco"],
    "B" : ["cisco"],
    "C" : ["cisco"]
}

router_network = {
    "cisco" : ["A", "B", "C"]
}




# 👉 Dizionario per tenere traccia dell'IP assegnato a ogni host
assigned_ips = {}

# 👉 Prepara iteratori per ogni rete
ip_iterators = {
    net: iter(ipaddress.ip_network(addr).hosts())  # .hosts() salta network e broadcast
    for net, addr in network_address.items()
}

for lan, hosts in network_host.items():
    for host in hosts:
        lab.new_machine(host, image = get_image_for_host(image_host, host))
        lab.connect_machine_to_link(host , lan)

        ip = next(ip_iterators[lan])+1  # Ottieni il prossimo IP disponibile
        assigned_ips[host] = str(ip)

        lab.create_file_from_list(
            [f"ip address add {ip}/24 dev eth0"],  # Usa l’IP assegnato
            host + ".startup"
        )

for router, lans in router_network.items() :
    lab.new_machine(router, image = "theb0ys/base")
    startup_lines = []
    for network in lans : 
        startup_lines.append(f"ip address add {ip}/24 dev eth0\n")
    
    lab.create_file_from_list(startup_lines, router+".startup")



    

# Deploy del lab
Kathara.get_instance().deploy_lab(lab)

# Output IP assegnati
print("📡 IP assegnati ai nodi:")
for host, ip in assigned_ips.items():
    print(f"{host}: {ip}")
