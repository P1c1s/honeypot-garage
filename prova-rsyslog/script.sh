#!/bin/bash
# Script per creare una rete Docker e 3 container basati sull'immagine "provasyslog"

set -e  # interrompe lo script in caso di errore

IMAGE_NAME="provasyslog"
NETWORK_NAME="rete-provasyslog"

# 1️⃣ Crea la rete se non esiste
if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    echo "Creo la rete $NETWORK_NAME..."
    docker network create "$NETWORK_NAME"
else
    echo "La rete $NETWORK_NAME esiste già."
fi

# 2️⃣ Avvia tre container collegati alla stessa rete
for i in 1 2 3; do
    CONTAINER_NAME="provasyslog_c$i"
    if docker ps -a --format '{{.Names}}' | grep -qw "$CONTAINER_NAME"; then
        echo "Il container $CONTAINER_NAME esiste già. Lo rimuovo e ricreo..."
        docker rm -f "$CONTAINER_NAME"
    fi

    echo "Avvio container $CONTAINER_NAME..."
    docker run -dit --name "$CONTAINER_NAME" --network "$NETWORK_NAME" "$IMAGE_NAME"
done

echo
echo "Container creati e in esecuzione:"
docker ps --filter "network=$NETWORK_NAME"
echo
echo "Puoi testare la comunicazione, ad esempio:"
echo "  docker exec -it provasyslog_c1 ping provasyslog_c2"
