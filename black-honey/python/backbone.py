from meta import lab
from mylib import *

# The main router with nat64 and bridged networks
nat64 = lab.new_machine("nat64", image="theb0ys/nat64:latest", privileged=True, bridged=True)
lab.connect_machine_to_link("nat64", "W", machine_iface_number = 0, mac_address=generate_mac())
nat64.add_meta("sysctl", "net.ipv4.conf.eth1.proxy_arp=1") # CHE COSA FA? DA CAPIRE
lab.get_machine("nat64").create_file_from_path("machines_configurations/nat64/nginx/default", "/etc/nginx/sites-available/default")
#lab.create_startup_file_from_path(nat64, "machines_startup_script/backbone/docker-entry-tayga.sh")

# DNS64
dns64 = lab.new_machine("dns64", image="theb0ys/dns64:latest")
lab.connect_machine_to_link("dns64", "W", machine_iface_number = 0, mac_address=generate_mac())
lab.create_startup_file_from_path(dns64, "machines_startup_script/backbone/docker-entry-dns64.sh")

fw = lab.new_machine("fw", image="theb0ys/base:latest")
lab.connect_machine_to_link("fw", "M2", machine_iface_number = 0, mac_address="00:00:00:00:02:01")
lab.connect_machine_to_link("fw", "I", machine_iface_number = 1, mac_address=generate_mac())
lab.connect_machine_to_link("fw", "E", machine_iface_number = 2, mac_address=generate_mac())
lab.connect_machine_to_link("fw", "W", machine_iface_number = 3, mac_address=generate_mac())
#lab.create_startup_file_from_path(fw, "machines_startup_script/backbone/fw.sh")

# Router cisco manages the networks A, B and C
cisco = lab.new_machine("cisco", image="theb0ys/base:latest")
lab.connect_machine_to_link("cisco", "M2", machine_iface_number = 0, mac_address="00:00:00:00:02:02")
lab.connect_machine_to_link("cisco", "I", machine_iface_number = 1, mac_address=generate_mac())
lab.connect_machine_to_link("cisco", "A", machine_iface_number = 2)
lab.connect_machine_to_link("cisco", "B", machine_iface_number = 3)
lab.connect_machine_to_link("cisco", "C", machine_iface_number = 4)
lab.get_machine("cisco").create_file_from_path("machines_configurations/cisco/radvd.conf", "/etc/radvd.conf")
#lab.create_startup_file_from_path(cisco, "machines_startup_script/backbone/cisco.sh")

# Router ciscos manages the networks S, F1, and F2
ciscos = lab.new_machine("ciscos", image="theb0ys/base:latest")
lab.connect_machine_to_link("ciscos", "M2", machine_iface_number = 0, mac_address="00:00:00:00:02:06")
lab.connect_machine_to_link("ciscos", "F2", machine_iface_number = 1, mac_address=generate_mac())
lab.connect_machine_to_link("ciscos", "F1", machine_iface_number = 2, mac_address=generate_mac())
lab.connect_machine_to_link("ciscos", "S", machine_iface_number = 3)
lab.connect_machine_to_link("ciscos", "E", machine_iface_number = 4, mac_address=generate_mac())
lab.get_machine("ciscos").create_file_from_path("machines_configurations/ciscos/radvd.conf", "/etc/radvd.conf")
#lab.create_startup_file_from_path(ciscos, "machines_startup_script/backbone/ciscos.sh")

# Router ciscod manages the networks D, F2, and F3
ciscod = lab.new_machine("ciscod", image="theb0ys/base:latest")
lab.connect_machine_to_link("ciscod", "M2", machine_iface_number = 0, mac_address="00:00:00:00:02:08")
lab.connect_machine_to_link("ciscod", "F2", machine_iface_number = 1, mac_address=generate_mac())
lab.connect_machine_to_link("ciscod", "F3", machine_iface_number = 2, mac_address=generate_mac())
lab.connect_machine_to_link("ciscod", "D", machine_iface_number = 3)
lab.get_machine("ciscod").create_file_from_path("machines_configurations/ciscod/radvd.conf", "/etc/radvd.conf")
#lab.create_startup_file_from_path(ciscod, "machines_startup_script/backbone/ciscod.sh")

# Router ciscoo manages the networks O, F3, and F1
ciscoo = lab.new_machine("ciscoo", image="theb0ys/base:latest")
lab.connect_machine_to_link("ciscoo", "M2", machine_iface_number = 0, mac_address="00:00:00:00:02:0a")
lab.connect_machine_to_link("ciscoo", "F3", machine_iface_number = 1, mac_address=generate_mac())
lab.connect_machine_to_link("ciscoo", "F1", machine_iface_number = 2, mac_address=generate_mac())
lab.connect_machine_to_link("ciscoo", "O", machine_iface_number = 3)
lab.get_machine("ciscoo").create_file_from_path("machines_configurations/ciscoo/radvd.conf", "/etc/radvd.conf")
#lab.create_startup_file_from_path(ciscoo, "machines_startup_script/backbone/ciscoo.sh")

#INSERIRE ROTTA DEAFULT NAT 64 -- BRIDGED

#Collegamento fw-nat
mac_add = fw.interfaces[3].mac_address
link_local = mac_to_ipv6_link_local(mac_add)              #funzione per ricavare link local da mac address
append_startup("nat64", f"ip -6 route add 2a04::/56 via {link_local} dev eth0")

mac_add = nat64.interfaces[0].mac_address
link_local = mac_to_ipv6_link_local(mac_add)              #funzione per ricavare link local da mac address
append_startup("fw", f"ip -6 route add default via {link_local} dev eth3")

#collegamento fw-cisco
mac_add = cisco.interfaces[1].mac_address
link_local = mac_to_ipv6_link_local(mac_add)              #funzione per ricavare link local da mac address
append_startup("fw", f"ip -6 route add 2a04::/60 via {link_local} dev eth1")

mac_add = fw.interfaces[1].mac_address
link_local = mac_to_ipv6_link_local(mac_add)              #funzione per ricavare link local da mac address
append_startup("cisco", f"ip -6 route add default via {link_local} dev eth1")

#collegamento fw-ciscos
mac_add = ciscos.interfaces[4].mac_address
link_local = mac_to_ipv6_link_local(mac_add)              #funzione per ricavare link local da mac address
append_startup("fw", f"ip -6 route add 2a04:0:0:10::/60 via {link_local} dev eth2")

mac_add = fw.interfaces[2].mac_address
link_local = mac_to_ipv6_link_local(mac_add)              #funzione per ricavare link local da mac address
append_startup("ciscos", f"ip -6 route add default via {link_local} dev eth4")

#collegamento ciscos-ciscod
mac_add = ciscod.interfaces[1].mac_address
link_local = mac_to_ipv6_link_local(mac_add)              #funzione per ricavare link local da mac address
append_startup("ciscos", f"ip -6 route add 2a04:0:0:11::/64 via {link_local} dev eth1")

mac_add = ciscos.interfaces[1].mac_address
link_local = mac_to_ipv6_link_local(mac_add)              #funzione per ricavare link local da mac address
append_startup("ciscod", f"ip -6 route add default via {link_local} dev eth1")

#collegamento ciscos-ciscoo
mac_add = ciscoo.interfaces[2].mac_address
link_local = mac_to_ipv6_link_local(mac_add)              #funzione per ricavare link local da mac address
append_startup("ciscos", f"ip -6 route add 2a04:0:0:12::/64 via {link_local} dev eth2")

mac_add = ciscos.interfaces[2].mac_address
link_local = mac_to_ipv6_link_local(mac_add)              #funzione per ricavare link local da mac address
append_startup("ciscoo", f"ip -6 route add default via {link_local} dev eth2")

#collegamento ciscoo-ciscod
mac_add = ciscod.interfaces[2].mac_address
link_local = mac_to_ipv6_link_local(mac_add)              #funzione per ricavare link local da mac address
append_startup("ciscoo", f"ip -6 route add 2a04:0:0:11::/64 via {link_local} dev eth1")

mac_add = ciscoo.interfaces[1].mac_address
link_local = mac_to_ipv6_link_local(mac_add)              #funzione per ricavare link local da mac address
append_startup("ciscod", f"ip -6 route add 2a04:0:0:12::/64 via {link_local} dev eth2")



def read_file_to_list(file_path):
    """
    Legge un file e restituisce il contenuto come lista di righe senza newline.
    
    :param file_path: percorso del file da leggere
    :return: lista di stringhe
    """
    
    with open(file_path, "r") as f:
        lines = f.read().splitlines()  # rimuove automaticamente \n
        # opzionale: rimuove spazi vuoti all'inizio/fine di ogni riga
        lines = [line.strip() for line in lines if line.strip()]
    return lines

# app = read_file_to_list("machines_startup_script/backbone/fw.sh")
# app += machine_startup["fw"]
# print(app)

for machine in machine_startup:
    machine_startup[machine]+=(read_file_to_list(f"machines_startup_script/backbone/{machine}.sh"))
    print(f"Startup di {machine} creato")
    lab.create_file_from_list(machine_startup[machine], f"{machine}.startup")   


