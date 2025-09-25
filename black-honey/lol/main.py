#!/usr/bin/python

from Kathara.manager.Kathara import Kathara
from Kathara.setting.Setting import Setting
Setting.get_instance().enable_ipv6 = True

from Kathara.model.Lab import Lab

lab = Lab("test")

cisco = lab.new_machine("cisco", image="theb0ys/base:latest")
lab.connect_machine_to_link("cisco", "A", machine_iface_number = 0)
lab.get_machine("cisco").create_file_from_path("machines_configurations/cisco/radvd.conf", "/etc/radvd.conf")
lab.create_file_from_string("ip -6 address add 2a04::1/64 dev eth0\n systemctl start radvd", "cisco.startup")   

openvpn = lab.new_machine("openvpn", image="theb0ys/base", privileged=True, bridged=True)
lab.connect_machine_to_link("openvpn", "A", machine_iface_number = 0)
# lab.create_startup_file_from_path(openvpn, "lol/a.sh")
# lab.create_file_from_string("ip -6 address add 2a04::2/64 dev eth0\n", "openvpn.startup")   

host = lab.new_machine("host", image="theb0ys/base")
lab.connect_machine_to_link("host", "A", machine_iface_number = 0)
lab.create_file_from_string("ip -6 address add 2a04::3/64 dev eth0", "host.startup")   

Kathara.get_instance().deploy_lab(lab)