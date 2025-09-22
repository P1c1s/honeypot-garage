#!/bin/bash
# Crea 3 container Docker basati su kathara/base sulla stessa rete

set -euo pipefail

IMAGE="kathara/base"
NETWORK="rete-kathara"

# 1️⃣ Verifica che l'immagine sia presente localmente
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "➡️  L'immagine '$IMAGE' non è presente. Provo a scaricarla..."
    docker pull "$IMAGE"
fi

# 2️⃣ Crea la rete se non esiste
if ! docker network inspect "$NETWORK" >/dev/null 2>&1; then
    echo "➡️  Creo la rete $NETWORK..."
    docker network create "$NETWORK"
else
    echo "✔️  La rete $NETWORK esiste già."
fi

# 3️⃣ Avvia tre container nella stessa rete
for i in 1 2 3; do
    NAME="kathara_c$i"
    # rimuove eventuale container con lo stesso nome
    if docker ps -a --format '{{.Names}}' | grep -qw "$NAME"; then
        echo "⚠️  Container $NAME già esistente, lo rimuovo..."
        docker rm -f "$NAME"
    fi
    echo "➡️  Avvio $NAME ..."
    docker run -dit --name "$NAME" --network "$NETWORK" "$IMAGE" \
        tail -f /dev/null
done

echo
echo "🎉 Container creati e in esecuzione sulla rete $NETWORK:"
docker ps --filter "network=$NETWORK"
echo
echo "Puoi testare la comunicazione ad esempio con:"
echo "  docker exec -it kathara_c1 ping kathara_c2"
