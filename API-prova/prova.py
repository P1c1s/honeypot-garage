from Kathara.manager.Kathara import Kathara
from Kathara.model.Lab import Lab

lab = Lab("Prova")

pc1 = lab.new_machine("pc1", **{"image":"theb0ys/base"})
pc2 = lab.new_machine("pc2", **{"image":"theb0ys/base"})
r = lab.new_machine("r", **{"image":"theb0ys/base"})


lab.connect_machine_to_link(pc1.name, "A")
lab.connect_machine_to_link(pc2.name, "A")
lab.connect_machine_to_link(r.name, "A")

lab.create_file_from_list(
    [
        "ip address add 192.168.0.1/24 on eth0", 
    ]
    , "r1.startup"
)

lab.create_file_from_list(
    [
        "ip address add 192.168.0.2/24 on eth0", 
    ]
    , "pc1.startup"
)

lab.create_file_from_list(
    [
        "ip address add 192.168.0.3/24 on eth0", 
    ]
    , "pc2.startup"
)