from meta import lab

# LAN O
switcho = lab.new_machine("switcho", image="theb0ys/base")
lab.connect_machine_to_link("switcho", "M1", machine_iface_number = 0, mac_address="00:00:00:00:02:0b")
lab.connect_machine_to_link("switcho", "O", machine_iface_number = 1)
lab.connect_machine_to_link("switcho", "O1", machine_iface_number = 2)
lab.create_startup_file_from_path(switcho, "machines_startup_script/switcho.sh")

pc1o = lab.new_machine("pc1o", image="theb0ys/base")
lab.connect_machine_to_link("pc1o", "O1", machine_iface_number = 0)
pc1o.add_meta("thinkpad", "net.ipv6.conf.eth0.accept_ra=2")
lab.create_startup_file_from_path(pc1o, "machines_startup_script/pc1o.sh")