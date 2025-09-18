import os
from Kathara.manager.Kathara import Kathara
from Kathara.model.Lab import Lab
from Kathara.model.Link import Link
from Kathara.model.Machine import Machine
from Kathara.setting.Setting import Setting
from Kathara.model.Interface import Interface
import docker
from Kathara.manager.docker.DockerLink import *
import ipaddress
from modules.mylib import *

import json


Setting.get_instance().enable_ipv6 = True

# Percorso del file JSON
file_path = 'lab.json'

# Legge i dati dal file JSON
with open(file_path, 'r') as json_file:
    dictionary = json.load(json_file)
    # Carica nella variabile lab_info la struttura con chiave lab_info
    lab_info = dictionary["lab_info"]
    # Carica nella variabile rete la struttura con chiave rete
    rete = dictionary["rete"]
    # Carica nella variabile machine_startup la struttura con chiave machine_startup
    machine_startup = dictionary["machine_startup"]
    # Carica nella variabile network_address la struttura con chiave network_address
    network_address = dictionary["network_address"]
    # Carica nella variabile image_host la struttura con chiave image_host
    image_host = dictionary["image_host"]
    # Carica nella variabile image_host la struttura con chiave image_host
    management_host = dictionary["management_host"]



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

# 👉 Prepara iteratori per ogni rete
ip_iterators = {
    net: iter(ipaddress.ip_network(addr).hosts())  # .hosts() salta network e broadcast
    for net, addr in network_address.items()
}

network_address["def"] = "default"

lab = Lab("Prova")
lab.description = lab_info["description"]
lab.version = lab_info["version"]
lab.author = lab_info["author"]
lab.email = lab_info["email"]
lab.web = lab_info["web"]


for router in rete:
    lab.new_machine(router, image = get_image_for_host(image_host, router))
    radvd_lines = [""]
    for i in range(len(rete[router]["lan"])) :          # creazione delle "zampe" lan del router
        lab.connect_machine_to_link(router, rete[router]["lan"][i], machine_iface_number = rete[router]["iface"][i])
        ip = next(ip_iterators[rete[router]["lan"][i]])
        machine_startup[router].append(f"ip address add {str(ip)}/64 dev eth{rete[router]["iface"][i]}")
        radvd_lines.append(radvd.replace("X", str(i)).replace("Y",str(ip)))                             # creazione configurazione radv con specifico prefix per ogni lan
    lab.get_machine(router).create_file_from_list(lines = radvd_lines, dst_path="/etc/radvd.conf")      # inserimento file configurazione demone radv
    for i in range(len(rete[router]["plan"])) :         # creazione delle "zampe" plan 
        lab.connect_machine_to_link(router, rete[router]["plan"][i], machine_iface_number = rete[router]["piface"][i], mac_address=generate_mac())

    if len(rete[router]["switch"]) > 0:
        for i in range(len(rete[router]["lan"])) :          # creazione degli switch per ogni zampa lan del router
            switch = list(rete[router]["switch"].keys())[i]
            lab.new_machine(switch, image = get_image_for_host(image_host, switch))
            lab.connect_machine_to_link(switch, rete[router]["lan"][i])
            machine_startup[switch].append("""ip link add name mainbridge type bridge\n
                                            ip link set dev eth0 master mainbridge""")
            index = 1
            for host in rete[router]["switch"][switch] :    # creazione degli host connessi alle zampe degli switch
                lab.new_machine(host, image = get_image_for_host(image_host, host))
                lab.connect_machine_to_link(switch, f"{rete[router]["lan"][i]}{index}")     # connessione punto-punto host-switch (a1, a2, b1, b2, ...)
                lab.connect_machine_to_link(host, f"{rete[router]["lan"][i]}{index}")
                ip = next(ip_iterators[rete[router]["lan"][i]])

                machine_startup[host].append(f"ip address add {str(ip)}/64 dev eth0\nip -6 route add default via {network_address[rete[router]["lan"][i]].replace("::/64", "::1")} dev eth0")
                machine_startup[switch].append(f"ip link set dev eth{index} master mainbridge")

                lab.get_machine(host).create_file_from_string("nameserver 2a04:0:0:0::4", "/etc/resolv.conf")
                index += 1
            machine_startup[switch].append("""ip link set up dev mainbridge\n
                                           brctl setageing mainbridge 600""")

            lab.create_file_from_list(machine_startup[switch], f"{switch}.startup")

    machine_startup[router].append("""chmod o-rw /etc/radvd.conf\n
                                   systemctl start radvd""")

for router in rete:

    if router == "fw" : 
        next_hop_router = find_router_connected_to_plan("I", rete, "fw")
        next_hop_iface = rete[next_hop_router]["piface"][rete[next_hop_router]["plan"].index("I")]
        mac = lab.get_machine(next_hop_router).interfaces[next_hop_iface].mac_address
        link_local = mac_to_ipv6_link_local(mac)
        machine_startup[router].append(f"ip -6 route add 2a04::/60 via {link_local} dev eth0\n")
                                      
        next_hop_router = find_router_connected_to_plan("E", rete, "fw")
        next_hop_iface = rete[next_hop_router]["piface"][rete[next_hop_router]["plan"].index("E")]
        mac = lab.get_machine(next_hop_router).interfaces[next_hop_iface].mac_address
        link_local = mac_to_ipv6_link_local(mac)
        machine_startup[router].append(f"ip -6 route add 2a04:0:0:10::/60 via {link_local} dev eth1\n")

        next_hop_router = find_router_connected_to_plan("N", rete, "fw")
        next_hop_iface = rete[next_hop_router]["piface"][rete[next_hop_router]["plan"].index("N")]
        mac = lab.get_machine(next_hop_router).interfaces[next_hop_iface].mac_address
        link_local = mac_to_ipv6_link_local(mac)
        machine_startup[router].append(f"ip -6 route add default via {link_local} dev eth2\n")

    elif router == "nat":
        next_hop_router = find_router_connected_to_plan("N", rete, "nat")
        next_hop_iface = rete[next_hop_router]["piface"][rete[next_hop_router]["plan"].index("N")]
        mac = lab.get_machine(next_hop_router).interfaces[next_hop_iface].mac_address
        link_local = mac_to_ipv6_link_local(mac)
        machine_startup[router].append(f"ip -6 route add 2a04::/56 via {link_local} dev eth0\n")

    else :
        for r in rete[router].get("route", []):
            dest_lan, plan = r.split("|")
            next_hop_router = find_router_connected_to_plan(plan, rete, router)

            # Trova interfaccia usata dal router corrente per quella plan
            iface_index = rete[router]["plan"].index(plan)
            iface_name = f"eth{rete[router]['piface'][iface_index]}"

            next_hop_iface = rete[next_hop_router]["piface"][rete[next_hop_router]["plan"].index(plan)]
            mac = lab.get_machine(next_hop_router).interfaces[next_hop_iface].mac_address
            link_local = mac_to_ipv6_link_local(mac)

            machine_startup[router].append(f"ip -6 route add {network_address[dest_lan]} via {link_local} dev {iface_name}")


    lab.get_machine(router).create_file_from_string("nameserver 2a04:0:0:0::4", "/etc/resolv.conf")


# creazione vlans (management lans)
for lan, hosts in management_host.items():
    for host in hosts: 
        mac_address = genera_mac_progressivi(lan)[management_host[lan].index(host)]
        lab.connect_machine_to_link(host, lan, mac_address=mac_address)
        if (lan == "M1") :
            machine_startup["pc1s"].append(f"echo '{mac_to_ipv6_link_local(mac_address)} {host}.local' >> /etc/hosts")
            machine_startup[host].append("useradd -m -p $(perl -e 'print crypt($ARGV[0], \"password\")' '1Password!') siserver")

        else:
            machine_startup["pc2s"].append(f"echo '{mac_to_ipv6_link_local(mac_address)} {host}.local' >> /etc/hosts")
            machine_startup[host].append("useradd -m -p $(perl -e 'print crypt($ARGV[0], \"password\")' '2Password!') sirouter")
        machine_startup[host].append("systemctl start ssh")

for machine in machine_startup:
    lab.create_file_from_list(machine_startup[machine], f"{machine}.startup")   


lab.get_machine("bind1").copy_directory_from_path("../configurazioni/bind1", "/etc/bind") 
lab.get_machine("wsa2").copy_directory_from_path("../configurazioni/wsa2/apache2/sites-available/", "/etc/apache2/sites-available/")
lab.get_machine("wsa2").copy_directory_from_path("../configurazioni/wsa2/html", "/var/www/html")
lab.get_machine("wsa2").copy_directory_from_path("../configurazioni/wsn/html", "/var/www/html")
lab.get_machine("wsn").copy_directory_from_path("../configurazioni/wsn/html", "/var/www/html")
lab.get_machine("wsn").copy_directory_from_path("../configurazioni/wsn/nginx", "/etc/nginx")
lab.get_machine("smb").copy_directory_from_path("../configurazioni/smb/samba", "/etc/samba")
lab.get_machine("mdb").copy_directory_from_path("../configurazioni/mdb/mysql/mariadb.conf.d", "/etc/mysql/mariadb.conf.d")      # -- da rivedere 
lab.get_machine("mdb").create_file_from_path("../configurazioni/mdb/mysql/my.cnf", "/etc/mysql/my.cnf")      # -- da rivedere 
lab.get_machine("mdb").copy_directory_from_path("../configurazioni/mdb/data", "/root")
lab.get_machine("wsa1").copy_directory_from_path("../configurazioni/wsa1/html/prova", "/var/www/html")
# lab.get_machine("mdb").copy_directory_from_path("../configurazioni/mdb/mysql/mariadb.conf.d", "/etc/mysql/mariadb.conf.d")
lab.get_machine("syslog").copy_directory_from_path("../configurazioni/syslog-server", "/etc")
lab.get_machine("wsa1").copy_directory_from_path("../configurazioni/syslog-client", "/etc")
lab.get_machine("wsa2").copy_directory_from_path("../configurazioni/syslog-client", "/etc")
lab.get_machine("smb").copy_directory_from_path("../configurazioni/smb/srv", "/srv")
lab.get_machine("smb").copy_directory_from_path("../configurazioni/smb/samba", "/etc/samba")



# lab.get_machine("fw").update_meta({"bridged":True})
lab.get_machine("nat").update_meta({"bridged":True})
lab.get_machine("wsa1").update_meta({"bridged":True})

# lab.new_machine("wireshark", image="lscr.io/linuxserver/wireshark")
# lab.get_machine("wireshark").update_meta({"bridged":True, "port":"3000:3000"})


# Deploy del lab
Kathara.get_instance().deploy_lab(lab)

print(next(Kathara.get_instance().get_machines_stats(lab_name=lab.name)))




# disabilitazione ipv6 ->       ip addr del 127.0.0.1/8 dev lo