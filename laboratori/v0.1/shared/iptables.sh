#!/bin/bash
iptables --line-numbers -vnL |\
  sed -E 's/^Chain.*$/\x1b[4m&\x1b[0m/' |\
  sed -E 's/^num.*/\x1b[33m&\x1b[0m/' |\
  sed -E '/([^y] )((REJECT|DROP))/s//\1\x1b[31m\3\x1b[0m/' |\
  sed -E '/([^y] )(ACCEPT)/s//\1\x1b[32m\2\x1b[0m/' |\
  sed -E '/([ds]pt[s]?:)([[:digit:]]+(:[[:digit:]]+)?)/s//\1\x1b[33;1m\2\x1b[0m/' |\
  sed -E '/([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}(\/([[:digit:]]){1,3}){0,1}/s//\x1b[36;1m&\x1b[0m/g' |\
  sed -E '/([^n] )(LOGDROP)/s//\1\x1b[33;1m\2\x1b[0m/'|\
  sed -E 's/ LOG /\x1b[36;1m&\x1b[0m/'