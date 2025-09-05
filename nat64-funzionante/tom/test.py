#!/usr/bin/python

from Kathara.manager.Kathara import Kathara
from Kathara.model.Lab import Lab
from Kathara.setting.Setting import Setting

lab = Lab("lab-nat64")

# Nat64
nat64 = lab.new_machine("nat64", image="kathara/tayga:latest", privileged=True, ipv6=True, bridged=True)
lab.connect_machine_to_link("nat64", "A", machine_iface_number = 0)
lab.create_startup_file_from_path(nat64, "docker-entry-tayga.sh")

# DNS64
dns64 = lab.new_machine("dns64", image="alpine-dns64", ipv6=True)
lab.connect_machine_to_link("dns64", "A", machine_iface_number = 0)
lab.create_startup_file_from_path(dns64, "docker-entry-dns64.sh")


# Host
host = lab.new_machine("host", image="theb0ys/base", ipv6=True)
lab.connect_machine_to_link("host", "A", machine_iface_number = 0)
lab.create_startup_file_from_path(host, "docker-entry-host.sh")

Kathara.get_instance().deploy_lab(lab)


# Kathara.get_instance().connect_tty_obj(nat64)

# Kathara.get_instance().undeploy_lab(lab=lab)
