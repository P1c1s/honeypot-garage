from Kathara.manager.Kathara import Kathara
from Kathara.model.Lab import Lab
import ipaddress

lab = Lab("rete")

webservers = ["wsa1", "wsa2", "nginx"]       #webserver --> image theb0ys/
database = ["mdb"]
samba = ["smb"]
dns = ["bind1", "bind2"]
vpn = ["ovpn"]


lana = ["bind1"]
lanb = ["wsa1", "mdb", "smb"]
lanc = ["wsa2", "ngnix", "ovpn", "bind2"]

macchine = {}       #dizionario macchine

#CREAZIONE MACCHINE

for m in webservers :
    macchine[m] = lab.new_machine(m, **{"image":"theb0ys/apache"})

for m in database :
    macchine[m] = lab.new_machine(m, **{"image":"theb0ys/mariadb"})

for m in samba :
    macchine[m] = lab.new_machine(m, **{"image":"theb0ys/samba"})

for m in dns :
   macchine[m] = lab.new_machine(m, **{"image":"theb0ys/base"})

# for m in vpn :
#     macchine[m] = lab.new_machine(m, **{"image":"theb0ys/base"})

for m in lana:
    lab.connect_machine_to_link(m, "A")

for m in lanb:
    lab.connect_machine_to_link(m, "B")

for m in lanc:
    lab.connect_machine_to_link(m, "C")








# lab.create_file_from_list(
#     [
#         "ip address add 192.168.0.1/24 on eth0", 
#     ]
#     , "r1.startup"
# )

# lab.create_file_from_list(
#     [
#         "ip address add 192.168.0.2/24 on eth0", 
#     ]
#     , "pc1.startup"
# )

# lab.create_file_from_list(
#     [
#         "ip address add 192.168.0.3/24 on eth0", 
#     ]
#     , "pc2.startup"
# )

Kathara.get_instance().deploy_lab(lab)
print(next(Kathara.get_instance().get_machines_stats(lab_name=lab.name)))