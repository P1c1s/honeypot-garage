from meta import lab


# LAN A
switcha = lab.new_machine("switcha", image="theb0ys/base:latest")
lab.connect_machine_to_link("switcha", "M2", machine_iface_number = 0, mac_address="00:00:00:00:02:03")
lab.connect_machine_to_link("switcha", "A", machine_iface_number = 1)
lab.connect_machine_to_link("switcha", "A1", machine_iface_number = 2)
lab.connect_machine_to_link("switcha", "A2", machine_iface_number = 3)
lab.connect_machine_to_link("switcha", "A3", machine_iface_number = 4)
lab.create_startup_file_from_path(switcha, "machines_startup_script/lan_a/switcha.sh")

# oldap = lab.new_machine("oldap", image="theb0ys/oldap:latest")
# lab.connect_machine_to_link("oldap", "M1", machine_iface_number = 0, mac_address="00:00:00:00:01:01")
# lab.connect_machine_to_link("oldap", "A1", machine_iface_number = 1)
# lab.create_startup_file_from_path(oldap, "machines_startup_script/lan_a/oldap.sh")

syslog = lab.new_machine("syslog", image="theb0ys/rsyslog:latest")
lab.connect_machine_to_link("syslog", "M1", machine_iface_number = 0, mac_address="00:00:00:00:01:02")
lab.connect_machine_to_link("syslog", "A2", machine_iface_number = 1)
lab.get_machine("syslog").copy_directory_from_path("machines_configurations/syslog-server", "/etc")
lab.create_startup_file_from_path(syslog, "machines_startup_script/lan_a/syslog.sh")

bind1 = lab.new_machine("bind1", image="theb0ys/bind:latest")
lab.connect_machine_to_link("bind1", "M1", machine_iface_number = 0, mac_address="00:00:00:00:01:03")
lab.connect_machine_to_link("bind1", "A3", machine_iface_number = 1)
bind1.copy_directory_from_path("machines_configurations/bind1", "/etc/bind") 
bind1.copy_directory_from_path("machines_configurations/syslog-client-bind12", "/etc") 
lab.create_startup_file_from_path(bind1, "machines_startup_script/lan_a/bind1.sh")
