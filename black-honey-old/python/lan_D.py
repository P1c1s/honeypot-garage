from meta import lab

# LAN D
switchd = lab.new_machine("switchd", image="theb0ys/base")
lab.connect_machine_to_link("switchd", "M1", machine_iface_number = 0, mac_address="00:00:00:00:02:09")
lab.connect_machine_to_link("switchd", "D", machine_iface_number = 1)
lab.connect_machine_to_link("switchd", "D1", machine_iface_number = 2)
lab.create_startup_file_from_path(switchd, "machines_startup_script/switchd.sh")

pc1d = lab.new_machine("pc1d", image="theb0ys/base")
lab.connect_machine_to_link("pc1d", "D1", machine_iface_number = 0)
lab.create_startup_file_from_path(pc1d, "machines_startup_script/pc1d.sh")
