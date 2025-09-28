#!/bin/bash
# Script to add Tayga route, update /etc/hosts, and rebuild the Kathara lab
# Each step is printed for better debugging and tracking

# --- STEP 1: Add Tayga route if it doesn't exist ---
ROUTE="172.17.0.128/25"
GATEWAY="172.17.0.2"
IFACE="docker0"

# Add Tayga route to host
if ! ip route show | grep -q "$ROUTE"; then
    echo "Route $ROUTE not found. Adding route via $GATEWAY dev $IFACE"
    sudo ip route add $ROUTE via $GATEWAY dev $IFACE
    echo "✅ Route added."
else
    echo "✅ Route $ROUTE already exists."
fi

# Update /etc/hosts with the specified domains ---
HOSTS_FILE="/etc/hosts"
IPV4="$GATEWAY"

DOMAINS=("manager.theboys.it"                                                                 # wsa1's virtual host
         "ecopulse.theboys.it" "invest.theboys.it" "quix.theboys.it" "techsolve.theboys.it"   # wsa2's virtual host
         "agency.theboys.it" "blackhoney.theboys.it" "myrecipe.theboys.it")                   # wsn's virtual host

echo "✅ Updating /etc/hosts"
for domain in "${DOMAINS[@]}"; do
    if ! grep -q "$domain" "$HOSTS_FILE"; then
        echo "$IPV4 $domain" >> "$HOSTS_FILE"
    fi
done

# Clean the Kathara lab ---
kathara wipe -f && echo "✅ Kathara lab cleaned."

# Run the main Python script ---
python3 python/main.py && echo "✅ Python script completed."
