from Kathara.manager.Kathara import Kathara
from Kathara.model.Lab import Lab
from Kathara.model.Link import Link
from Kathara.model.Machine import Machine
import ipaddress
from modules.mylib import *


# dict = {
#     cisco : {
#         lan : [a, b, c],
#         iface : [0, 1, 2],
#         macs : [generazione automatica],
#         ip : [generazione automatica], 
#         switch : [
            
#         ],
#         dest : { dest : next_hop}
#     }
#      ciscos : {}
#      ciscod : {}
# }

network_address = {
    "A" : "192.168.23.0/24",
    "B" : "192.168.24.0/24",
    "C" : "192.168.25.0/24", 
    "F1" : "192.168.26.0/24", 
    "F2" : "192.168.27.0/24", 
    "S" : "192.168.28.0/24", 
}

rete = {
    "cisco" : {
        "lan" : ["A", "B", "C"],
        "plan" : [], 
        "iface" : [0, 1, 2],
        "pface" : [],
        "switch" : {
            "switcha" : ["oldap", "bind1"],
            "switchb" : ["smb", "mdb", "wsa1"],
            "switchc" : ["ovpn", "bind2", "wsa2", "nginx"]
        }
    },
    "ciscos" : {
        "lan" : ["S"],
        "plan" : ["F1", "F2"],
        "iface" : [0],
        "piface" : [1, 2],
        "switch" : {
            "switchs" : ["pc1s", "pc2s"],
        }
    }
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
    lab.new_machine(router)
    startup_lines = []
    for i in range(len(rete[router]["lan"])) :
        lab.connect_machine_to_link(router, rete[router]["lan"][i], machine_iface_number = rete[router]["iface"][i])
        ip = next(ip_iterators[rete[router]["lan"][i]])
        startup_lines.append(f"ip address add {str(ip)}/24 dev eth{rete[router]["iface"][i]}")
    for i in range(len(rete[router]["plan"])) :
        lab.connect_machine_to_link(router, rete[router]["plan"][i], machine_iface_number = rete[router]["piface"][i])
        ip = next(ip_iterators[rete[router]["plan"][i]])
        startup_lines.append(f"ip address add {str(ip)}/24 dev eth{rete[router]["piface"][i]}")

    for i in range(len(rete[router]["lan"])) :
        switch = list(rete[router]["switch"].keys())[i]
        lab.new_machine(switch)
        lab.connect_machine_to_link(switch, rete[router]["lan"][i])

        index = 1
        for host in rete[router]["switch"][switch] :
            lab.new_machine(host)
            lab.connect_machine_to_link(switch, f"{rete[router]["lan"][i]}{index}")
            lab.connect_machine_to_link(host, f"{rete[router]["lan"][i]}{index}")
            index += 1
            ip = next(ip_iterators[rete[router]["lan"][i]])
            lab.create_file_from_list([f"ip address add {str(ip)}/24 dev eth0"], f"{host}.startup")

        lab.create_file_from_list([
            "ip link add name mainbridge type bridge",
            "ip link set dev eth0 master mainbridge", 
            "ip link set dev eth1 master mainbridge", 
            "ip link set dev eth2 master mainbridge", 
            "ip link set up dev mainbridge", 
            "brctl setageing mainbridge 600"
        ], "switcha.startup")



    lab.create_file_from_list(startup_lines, f"{router}.startup")

# Deploy del lab
Kathara.get_instance().deploy_lab(lab)
print(next(Kathara.get_instance().get_machines_stats(lab_name=lab.name)))
