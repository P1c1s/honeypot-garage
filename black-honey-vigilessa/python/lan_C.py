from meta import lab


# LAN C
switchc = lab.new_machine("switchc", image="theb0ys/base:latest")
lab.connect_machine_to_link("switchc", "M2", machine_iface_number = 0, mac_address="00:00:00:00:02:05")
lab.connect_machine_to_link("switchc", "C", machine_iface_number = 1)
lab.connect_machine_to_link("switchc", "C1", machine_iface_number = 2)
lab.connect_machine_to_link("switchc", "C2", machine_iface_number = 3)
lab.connect_machine_to_link("switchc", "C3", machine_iface_number = 4)
lab.connect_machine_to_link("switchc", "C4", machine_iface_number = 5)
lab.create_startup_file_from_path(switchc, "machines_startup_script/lan_c/switchc.sh")

wsa2 = lab.new_machine("wsa2", image="theb0ys/apache:latest")
lab.connect_machine_to_link("wsa2", "M1", machine_iface_number = 0, mac_address="00:00:00:00:01:07")
lab.connect_machine_to_link("wsa2", "C1", machine_iface_number = 1)
lab.get_machine("wsa2").copy_directory_from_path("machines_configurations/wsa2/apache2/sites-available", "/etc/apache2/sites-available")
lab.get_machine("wsa2").copy_directory_from_path("machines_configurations/wsa2/html", "/var/www/html")
lab.get_machine("wsa2").copy_directory_from_path("machines_configurations/syslog-client-wsa12", "/etc")
lab.create_startup_file_from_path(wsa2, "machines_startup_script/lan_c/wsa2.sh")

wsn = lab.new_machine("wsn", image="theb0ys/nginx:latest")
lab.connect_machine_to_link("wsn", "M1", machine_iface_number = 0, mac_address="00:00:00:00:01:08")
lab.connect_machine_to_link("wsn", "C2", machine_iface_number = 1)
lab.get_machine("wsn").copy_directory_from_path("machines_configurations/wsn/html", "/var/www/html")
lab.get_machine("wsn").copy_directory_from_path("machines_configurations/wsn/nginx", "/etc/nginx")
lab.get_machine("wsn").copy_directory_from_path("machines_configurations/syslog-client-wsn", "/etc")
lab.create_startup_file_from_path(wsn, "machines_startup_script/lan_c/wsn.sh")

# It needs to privileged permission to work
ovpn = lab.new_machine("ovpn", image="openvpn/openvpn-as:latest", privileged = True)
lab.connect_machine_to_link("ovpn", "M1", machine_iface_number = 0, mac_address="00:00:00:00:01:09")
lab.connect_machine_to_link("ovpn", "C3", machine_iface_number = 1)
# lab.create_startup_file_from_path(ovpn, "machines_startup_script/lan_c/ovpn.sh")

bind2 = lab.new_machine("bind2", image="theb0ys/bind:latest")
lab.connect_machine_to_link("bind2", "M1", machine_iface_number = 0, mac_address="00:00:00:00:01:0a")
lab.connect_machine_to_link("bind2", "C4", machine_iface_number = 1)
bind2.copy_directory_from_path("machines_configurations/bind2", "/etc/bind") 
lab.get_machine("bind2").copy_directory_from_path("machines_configurations/syslog-client-bind12", "/etc")
lab.create_startup_file_from_path(bind2, "machines_startup_script/lan_c/bind2.sh")

