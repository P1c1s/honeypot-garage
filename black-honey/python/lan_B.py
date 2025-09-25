from meta import lab

# LAN B
switchb = lab.new_machine("switchb", image="theb0ys/base")
lab.connect_machine_to_link("switchb", "M2", machine_iface_number = 0, mac_address="00:00:00:00:02:04")
lab.connect_machine_to_link("switchb", "B", machine_iface_number = 1)
lab.connect_machine_to_link("switchb", "B1", machine_iface_number = 2)
lab.connect_machine_to_link("switchb", "B2", machine_iface_number = 3)
lab.connect_machine_to_link("switchb", "B3", machine_iface_number = 4)
lab.create_startup_file_from_path(switchb, "machines_startup_script/lan_b/switchb.sh")

wsa1 = lab.new_machine("wsa1", image="theb0ys/apache")
lab.connect_machine_to_link("wsa1", "M1", machine_iface_number = 0, mac_address="00:00:00:00:01:04")
lab.connect_machine_to_link("wsa1", "B1", machine_iface_number = 1)
lab.get_machine("wsa1").copy_directory_from_path("machines_configurations/wsa1/html", "/var/www/html")
lab.get_machine("wsa1").create_file_from_path("machines_configurations/wsa1/apache2/sites-available/000-default.conf", "/etc/apache2/sites-available/000-default.conf")
lab.get_machine("wsa1").copy_directory_from_path("machines_configurations/syslog-client", "/etc")
lab.create_startup_file_from_path(wsa1, "machines_startup_script/lan_b/wsa1.sh")

mdb = lab.new_machine("mdb", image="theb0ys/mariadb")
lab.connect_machine_to_link("mdb", "M1", machine_iface_number = 0, mac_address="00:00:00:00:01:05")
lab.connect_machine_to_link("mdb", "B2", machine_iface_number = 1)
lab.get_machine("mdb").copy_directory_from_path("machines_configurations/mdb/mysql/mariadb.conf.d", "/etc/mysql/mariadb.conf.d")      # -- da rivedere 
lab.get_machine("mdb").copy_directory_from_path("machines_configurations/mdb/data", "/root")
lab.create_startup_file_from_path(mdb, "machines_startup_script/lan_b/mdb.sh")

smb = lab.new_machine("smb", image="theb0ys/samba")
lab.connect_machine_to_link("smb", "M1", machine_iface_number = 0, mac_address="00:00:00:00:01:06")
lab.connect_machine_to_link("smb", "B3", machine_iface_number = 1)
lab.get_machine("smb").copy_directory_from_path("machines_configurations/smb/srv", "/srv")
lab.get_machine("smb").copy_directory_from_path("machines_configurations/smb/samba", "/etc/samba")
lab.create_startup_file_from_path(smb, "machines_startup_script/lan_b/smb.sh")
