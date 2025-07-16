from Kathara.manager.Kathara import Kathara
from Kathara.model.Lab import Lab
from Kathara.model.Link import Link
from Kathara.model.Machine import Machine
from Kathara.setting.Setting import Setting
from Kathara.model.Interface import Interface
import ipaddress
from modules.mylib import *

import json


Setting.get_instance().enable_ipv6 = True

# settings.save_to_disk()

# Percorso del file JSON
file_path = 'lab.json'

# Leggere i dati dal file JSON
with open(file_path, 'r') as json_file:
    rete = json.load(json_file)

radvd = """
interface ethX
{
	AdvSendAdvert on;
	MinRtrAdvInterval 3;
	MaxRtrAdvInterval 9;
	AdvDefaultLifetime 27;
	prefix Y/64 {};
};
"""



# 2a04:0000:0000:0000::/56

network_address = {
    "A" : "2a04:0:0:0001::/64",
    "B" : "2a04:0:0:0002::/64",
    "C" : "2a04:0:0:0003::/64", 
    "S" : "2a04:0:0:0004::/64",  
    "D" : "2a04:0:0:0005::/64", 
    "O" : "2a04:0:0:0006::/64", 
    "G" : "2a04:0:0:0007::/64", 

}

# cambiare immagine per switch con minimo indispensabile
image_host = {
    "theb0ys/apache": ["wsa1", "wsa2"],
    "theb0ys/base": ["bind1", "bind2", "nginx", "ovpn", "cisco", "ciscos", "ciscod", "ciscoo", "switcha", "switchb", "switchc", "fw", "pc1s", "pc2s", "pc1d", "pc1o"],
    "theb0ys/mariadb": ["mdb"],
    "theb0ys/samba": ["smb"],
}

router_startup = {
    "cisco" : "",
    "ciscos" : "",
    "ciscod" : "",
    "ciscoo" : "",
}


# 👉 Dizionario per tenere traccia dell'IP assegnato a ogni host
assigned_ips = {}

# 👉 Prepara iteratori per ogni rete
ip_iterators = {
    net: iter(ipaddress.ip_network(addr).hosts())  # .hosts() salta network e broadcast
    for net, addr in network_address.items()
}

network_address["def"] = "default"

lab = Lab("Prova")


for router in rete:
    lab.new_machine(router, image = get_image_for_host(image_host, router))
    startup_lines = []
    radvd_lines = [""]
    for i in range(len(rete[router]["lan"])) :          # creazione delle "zampe" lan del router
        lab.connect_machine_to_link(router, rete[router]["lan"][i], machine_iface_number = rete[router]["iface"][i])
        ip = next(ip_iterators[rete[router]["lan"][i]])
        startup_lines.append(f"ip address add {str(ip)}/64 dev eth{rete[router]["iface"][i]}")
        radvd_lines.append(radvd.replace("X", str(i)).replace("Y",str(ip)))                             # creazione configurazione radv con specifico prefix per ogni lan
    lab.get_machine(router).create_file_from_list(lines = radvd_lines, dst_path="/etc/radvd.conf")      # inserimento file configurazione demone radv
    for i in range(len(rete[router]["plan"])) :         # creazione delle "zampe" plan 
        lab.connect_machine_to_link(router, rete[router]["plan"][i], machine_iface_number = rete[router]["piface"][i], mac_address=generate_mac())

    if len(rete[router]["switch"]) > 0:
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

                lab.create_file_from_list([f"ip address add {str(ip)}/64 dev eth0\nip -6 route add default via {network_address[rete[router]["lan"][i]].replace("::/64", "::1")} dev eth0"], f"{host}.startup")
                startup_lines_switch.append(f"ip link set dev eth{index} master mainbridge")
                index += 1

            startup_lines_switch += ["ip link set up dev mainbridge", 
                                    "brctl setageing mainbridge 600"]

            lab.create_file_from_list(startup_lines_switch, f"{switch}.startup")
    

    startup_lines += ["chmod o-rw /etc/radvd.conf",                     # configurazione demone radv
                    "systemctl start radvd" ]

    router_startup[router] = startup_lines


for router in rete:
    startup_lines = router_startup[router]

    for r in rete[router].get("route", []):
        dest_lan, plan = r.split("|")
        next_hop_router = find_router_connected_to_plan(plan, rete, router)

        # Trova interfaccia usata dal router corrente per quella plan
        iface_index = rete[router]["plan"].index(plan)
        iface_name = f"eth{rete[router]['piface'][iface_index]}"

        next_hop_iface = rete[next_hop_router]["piface"][rete[next_hop_router]["plan"].index(plan)]
        # mac = generate_mac_from_router_iface(next_hop_router, next_hop_iface)
        mac = lab.get_machine(next_hop_router).interfaces[next_hop_iface].mac_address
        link_local = mac_to_ipv6_link_local(mac)


        startup_lines.append(f"ip -6 route add {network_address[dest_lan]} via {link_local} dev {iface_name}")
    
    lab.create_file_from_list(startup_lines, f"{router}.startup")
    
#   --> generare tutti i mac address per generare indirizzi ipv6 link-local

# Deploy del lab
Kathara.get_instance().deploy_lab(lab)
print(next(Kathara.get_instance().get_machines_stats(lab_name=lab.name)))

