import os
from Kathara.manager.Kathara import Kathara
from Kathara.model.Lab import Lab
from Kathara.model.Link import Link
from Kathara.model.Machine import Machine
from Kathara.setting.Setting import Setting
from Kathara.model.Interface import Interface
from Kathara.manager.docker.DockerLink import *

Setting.get_instance().enable_ipv6 = True

lab = Lab("lab-nat64")

# Nat64
lab.new_machine("nat64", image="danehans/tayga:latest", privileged=True, ipv6=True, bridged=True)
lab.connect_machine_to_link("nat64", "A", machine_iface_number = 0)
lab.create_file_from_list([
    "#echo 'net.ipv6.conf.all.disable_ipv6=0' >> /etc/sysctl.conf",
    "echo 'net.ipv6.conf.all.forwarding=1' >> /etc/sysctl.conf",
    "sysctl -p",
    "ip -6 address add fd00:dead:beef::100/48 dev eth0", 
], "nat64.startup")
#lab.get_machine("nat64").update_meta({"bridged":True, ipv6=True})

# Dns64
# lab.new_machine("dns64", image="theb0ys/dns64", privileged=True)
# lab.connect_machine_to_link("dns64", "A", machine_iface_number = 0)
# lab.create_file_from_list([
#     "echo 'net.ipv6.conf.all.disable_ipv6=0' >> /etc/sysctl.conf",
#     "echo 'net.ipv6.conf.all.forwarding=1' >> /etc/sysctl.conf",
#     "sysctl -p",
#     "ip -6 address add fd00:dead:beef::200/48 dev eth0",
#     "echo 'nameserver fd00:dead:beef::200' >> /etc/resolv.conf"
# ], "dns64.startup")
#lab.get_machine("dns64").copy_directory_from_path("bind/", "/etc/bind/") 

#lab.get_machine("dns64").create_file_from_path("bind/named.conf", "/etc/bind/named.conf")

# Host
lab.new_machine("host", image="theb0ys/base", privileged=False)
lab.connect_machine_to_link("host", "A", machine_iface_number = 0)
lab.create_file_from_list([
    "ip -6 address add fd00:dead:beef::2/48 dev eth0",
    "ip -6 route add 2001:db8:64:ff9b::/96 via fd00:dead:beef::100",
    "echo 'nameserver fd00:dead:beef::200' >> /etc/resolv.conf"
], "host.startup")

Kathara.get_instance().deploy_lab(lab)

