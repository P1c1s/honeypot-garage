from meta import lab

# LAN S
switchs = lab.new_machine("switchs", image="theb0ys/base")
lab.connect_machine_to_link("switchs", "M1", machine_iface_number = 0, mac_address="00:00:00:00:02:07")
lab.connect_machine_to_link("switchs", "S", machine_iface_number = 1)
lab.connect_machine_to_link("switchs", "S1", machine_iface_number = 2)
lab.connect_machine_to_link("switchs", "S2", machine_iface_number = 3)
lab.create_startup_file_from_path(switchs, "machines_startup_script/lan_s/switchs.sh")

pc1s = lab.new_machine("pc1s", image="theb0ys/base")
lab.connect_machine_to_link("pc1s", "M1", machine_iface_number = 0, mac_address="00:00:00:00:02:0b")
lab.connect_machine_to_link("pc1s", "S1", machine_iface_number = 1)
lab.create_startup_file_from_path(pc1s, "machines_startup_script/lan_s/pc1s.sh")

pc2s = lab.new_machine("pc2s", image="theb0ys/base")
lab.connect_machine_to_link("pc2s", "M2", machine_iface_number = 0, mac_address="00:00:00:00:02:0c")
lab.connect_machine_to_link("pc2s", "S2", machine_iface_number = 1)
lab.create_startup_file_from_path(pc2s, "machines_startup_script/lan_s/pc2s.sh")