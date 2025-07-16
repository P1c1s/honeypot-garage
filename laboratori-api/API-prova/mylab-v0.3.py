from Kathara.manager.Kathara import Kathara
from Kathara.model.Lab import Lab
from Kathara.model.Link import Link
from Kathara.model.Machine import Machine
import ipaddress
from modules.mylib import *

import json

# Percorso del file JSON
file_path = 'lab.json'

# Leggere i dati dal file JSON
with open(file_path, 'r') as json_file:
    rete = json.load(json_file)


network_address = {
    "A" : "192.168.23.0/24",
    "B" : "192.168.24.0/24",
    "C" : "192.168.25.0/24", 
    "F1" : "192.168.26.0/24", 
    "F2" : "192.168.27.0/24", 
    "S" : "192.168.28.0/24", 
}

# cambiare immagine per switch con minimo indispensabile
image_host = {
    "theb0ys/apache": ["wsa1", "wsa2"],
    "theb0ys/base": ["bind1", "bind2", "nginx", "ovpn", "cisco", "ciscos", "ciscod", "ciscoo", "switcha", "switchb", "switchc"],
    "theb0ys/mariadb": ["mdb"],
    "theb0ys/samba": ["smb"],
}



# 👉 Dizionario per tenere traccia dell'IP assegnato a ogni host
assigned_ips = {}

# 👉 Prepara iteratori per ogni rete
ip_iterators = {
    net: iter(ipaddress.ip_network(addr).hosts())  # .hosts() salta network e broadcast
    for net, addr in network_address.items()
}

lab = Lab("Prova")


for router in rete:
    lab.new_machine(router, image = get_image_for_host(image_host, router))
    startup_lines = []
    for i in range(len(rete[router]["lan"])) :          # creazione delle "zampe" lan del router
        lab.connect_machine_to_link(router, rete[router]["lan"][i], machine_iface_number = rete[router]["iface"][i])
        ip = next(ip_iterators[rete[router]["lan"][i]])
        startup_lines.append(f"ip address add {str(ip)}/24 dev eth{rete[router]["iface"][i]}")
    for i in range(len(rete[router]["plan"])) :         # creazione delle "zampe" plan 
        lab.connect_machine_to_link(router, rete[router]["plan"][i], machine_iface_number = rete[router]["piface"][i])
        ip = next(ip_iterators[rete[router]["plan"][i]])
        startup_lines.append(f"ip address add {str(ip)}/24 dev eth{rete[router]["piface"][i]}")

    for i in range(len(rete[router]["lan"])) :          # creazione degli switch per ogni zampa lan del router
        switch = list(rete[router]["switch"].keys())[i]
        lab.new_machine(switch, image = get_image_for_host(image_host, switch))
        lab.connect_machine_to_link(switch, rete[router]["lan"][i])

        startup_lines_switch = ["ip link add name mainbridge type bridge",
                                "ip link set dev eth0 master mainbridge"]

        index = 1
        for host in rete[router]["switch"][switch] :    # creazione degli host connessi alle zampe degli switch
            lab.new_machine(host, image = get_image_for_host(image_host, host))
            lab.connect_machine_to_link(switch, f"{rete[router]["lan"][i]}{index}")     # connessione punto-punto host-switch (a1, a2, b1, b2, ...)
            lab.connect_machine_to_link(host, f"{rete[router]["lan"][i]}{index}")
            ip = next(ip_iterators[rete[router]["lan"][i]])
            lab.create_file_from_list([f"ip address add {str(ip)}/24 dev eth0"], f"{host}.startup")
            startup_lines_switch.append(f"ip link set dev eth{index} master mainbridge")
            index += 1

        startup_lines_switch += ["ip link set up dev mainbridge", 
                                "brctl setageing mainbridge 600"]

        lab.create_file_from_list(startup_lines_switch, f"{switch}.startup")



    lab.create_file_from_list(startup_lines, f"{router}.startup")

# Deploy del lab
Kathara.get_instance().deploy_lab(lab)
print(next(Kathara.get_instance().get_machines_stats(lab_name=lab.name)))
