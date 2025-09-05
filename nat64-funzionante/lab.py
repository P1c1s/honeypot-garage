from Kathara.manager.Kathara import Kathara
from Kathara.model.Lab import Lab
from Kathara.model.Link import Link
from Kathara.model.Machine import Machine
from Kathara.setting.Setting import Setting
from Kathara.model.Interface import Interface
from Kathara.manager.docker.DockerLink import *

lab = Lab("prova-tayga")
nat = lab.new_machine("nat64", image="danehans/tayga:latest", privileged=True)
lab.connect_machine_to_link(nat.name, "A", machine_iface_number = 0)
lab.create_file_from_list(['ip address add fd00:dead:beef::100 dev nat64',
                           'ip address add 172.18.0.100 dev nat64'
                           ], "nat64.startup")   



pc1 = lab.new_machine("pc1", image="theb0ys/base", privileged=False)
lab.connect_machine_to_link(pc1.name, "A", machine_iface_number = 0)
nat.create_file_from_list([
    "ip address add 172.18.0.101/16 dev eth0"
], "nat64.sh")

lab.get_machine("nat64").update_meta({"bridged":True})

Kathara.get_instance().deploy_lab(lab)

