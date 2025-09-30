#!/bin/bash

apt install -y suricata
suricata-update
systemctl restart suricata
