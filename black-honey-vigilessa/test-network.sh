#!/bin/bash

# Example of use of it 
# cat test-network.sh | docker exec -i <container> bash

# ANSI escape colors
BLUE='\033[1;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NOCOLOR='\033[0m' 

# Network IPv6 adress's host 
addresses=("2a04::1" "2a04::2" "2a04::3" "2a04::4"                                            # Lan A
           "2a04:0:0:1::1" "2a04:0:0:1::2" "2a04:0:0:1::3" "2a04:0:0:1::4"                    # Lan B
           "2a04:0:0:2::1" "2a04:0:0:2::2" "2a04:0:0:2::3" "2a04:0:0:2::4" "2a04:0:0:2::5")   # Lan C

domains=("oldap.theboys.it" "syslog.theboys.it" "bind1.theboys.it"                            # Lan A
         "wsa1.theboys.it" "mdb.theboys.it" "smb.theboys.it"                                  # Lan B
         "wsa2.theboys.it" "wsn.theboys.it" "ovpn.theboys.it" "bind2.theboys.it"              # Lan C
         "manager.theboys.it"                                                                 # wsa1's virtual host
         "ecopulse.theboys.it" "invest.theboys.it" "quix.theboys.it" "techsolve.theboys.it"   # wsa2's virtual host
         "blackhoney.theboys.it" "myrecipe.theboys.it" "agency.theboys.it"                    # wsn's virtual host
         "google.com")                                                                        # Internet

managed1_address=("oldap.local" "syslog.local" "bind1.local"                                  # Lan A
                 "wsa1.local" "mdb.local" "smb.local"                                         # Lan B
                 "wsa2.local" "wsn.local" "ovpn.local" "bind2.tlocal")                        # Lan C

managed1_address=("oldap.local" "syslog.local" "bind1.local"                                  # Lan A
                 "wsa1.local" "mdb.local" "smb.local"                                         # Lan B
                 "wsa2.local" "wsn.local" "ovpn.local" "bind2.tlocal")                        # Lan C

# Array degli indirizzi IPv6 per Managed_1
managed1_addresses=(
    "fe80::200:ff:fe00:101"
    "fe80::200:ff:fe00:102"
    "fe80::200:ff:fe00:103"
    "fe80::200:ff:fe00:104"
    "fe80::200:ff:fe00:105"
    "fe80::200:ff:fe00:106"
    "fe80::200:ff:fe00:107"
    "fe80::200:ff:fe00:108"
    "fe80::200:ff:fe00:109"
    "fe80::200:ff:fe00:10a"
    "fe80::200:ff:fe00:10b"
)

managed2_addresses=(
    "fe80::200:ff:fe00:201"
    "fe80::200:ff:fe00:202"
    "fe80::200:ff:fe00:203"
    "fe80::200:ff:fe00:204"
    "fe80::200:ff:fe00:205"
    "fe80::200:ff:fe00:206"
    "fe80::200:ff:fe00:207"
    "fe80::200:ff:fe00:208"
    "fe80::200:ff:fe00:209"
    "fe80::200:ff:fe00:20a"
    "fe80::200:ff:fe00:20b"
    "fe80::200:ff:fe00:20c"
)

# Function to test reachability
function reachability_test(){
    echo -e "${BLUE}[Check network reachability]${NOCOLOR}"
    for address in "${addresses[@]}"; do
        if ping6 -qc 1 "$address" > /dev/null; then
            echo -e "${GREEN}+ Success ping to $address${NOCOLOR}"
        else
            echo -e "${RED}- Error ping to $address${NOCOLOR}"
        fi
    done
}

# Function to test domain reachability
function domain_reachability_test(){
    echo -e "${BLUE}[Check domain reachability]${NOCOLOR}"
    for domain in "${domains[@]}"; do
        if ping -c 1 "$domain" > /dev/null; then
            echo -e "${GREEN}+ Success ping to $domain${NOCOLOR}"
        else
            echo -e "${RED}- Error ping to $domain${NOCOLOR}"
        fi
    done
}

# Function to test reachability of Lan Managed_1
function reachability_test_m1(){
    echo -e "${BLUE}[Check network reachability]${NOCOLOR}"
    for adress in "${managed1_addresses[@]}"; do
        if ping6 -qc 1 "$adress"%eth0 > /dev/null; then
            echo -e "${GREEN}+ Success ping to $adress${NOCOLOR}"
        else
            echo -e "${RED}- Error ping to $adress${NOCOLOR}"
        fi
    done
}

# Function to test reachability of Lan Managed_1
function reachability_test_m2(){
    echo -e "${BLUE}[Check network reachability]${NOCOLOR}"
    for adress in "${managed2_addresses[@]}"; do
        if ping6 -qc 1 "$adress"%eth0 > /dev/null; then
            echo -e "${GREEN}+ Success ping to $adress${NOCOLOR}"
        else
            echo -e "${RED}- Error ping to $adress${NOCOLOR}"
        fi
    done
}

# reachability_test
# domain_reachability_test
# reachability_test_m1
# reachability_test_m2