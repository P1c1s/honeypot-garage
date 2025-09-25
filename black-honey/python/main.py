#!/usr/bin/python

from Kathara.manager.Kathara import Kathara
from Kathara.setting.Setting import Setting
Setting.get_instance().enable_ipv6 = True

from meta import lab

import backbone
import lan_A
import lan_B
import lan_C
import lan_S
import lan_D
import lan_O


red_hornet = lab.new_machine("red_hornet", image = "theb0ys/red-hornet:latest")
lab.connect_machine_to_link("red_hornet", "A", machine_iface_number = 0)

Kathara.get_instance().deploy_lab(lab)


# Notes
#
# Networks M1 and M2 are two management networks used by system administrators 
# to connect remotely via SSH. To ensure that the hosts always maintain 
# the same IP address, MAC addresses are forced deterministically.
#
# The I, E, F1, F2, and F3 networks are used for routing. To ensure
# the proper operation of the routes, the routers connected to these 
# interfaces have link-local addresses set statically, enforced through 
# the configuration of MAC addresses.