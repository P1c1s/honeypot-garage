#!/bin/bash

# Controlla se è stato fornito un argomento
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <tabella>"
    echo "Esempi: $0 filter"
    echo "        $0 nat"
    exit 1
fi

# Funzione per visualizzare le regole di iptables
function show_iptables {
    local table=$1
    iptables -t "$table" --line-numbers -vnL |\
    sed -E 's/^Chain.*$/\x1b[4m&\x1b[0m/' |\
    sed -E 's/^num.*/\x1b[33m&\x1b[0m/' |\
    sed -E '/([^y] )((REJECT|DROP))/s//\1\x1b[31m\3\x1b[0m/' |\
    sed -E '/([^y] )(ACCEPT)/s//\1\x1b[32m\2\x1b[0m/' |\
    sed -E '/([ds]pt[s]?:)([[:digit:]]+(:[[:digit:]]+)?)/s//\1\x1b[33;1m\2\x1b[0m/' |\
    sed -E '/([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}(\/([[:digit:]]){1,3}){0,1}/s//\x1b[36;1m&\x1b[0m/g' |\
    sed -E '/([^n] )(LOGDROP)/s//\1\x1b[33;1m\2\x1b[0m/'|\
    sed -E 's/ LOG /\x1b[36;1m&\x1b[0m/'
}

# Passa il parametro come nome della tabella
table_name=$1

# Mostra le regole della tabella specificata
echo "Regole della tabella $table_name:"
show_iptables "$table_name"

