#!/bin/bash

# Pull base image
echo "🔹 Pulling theb0ys/base:latest"
docker pull theb0ys/base:latest

# Pull apache image
echo "🔹 Pulling theb0ys/apache:latest"
docker pull theb0ys/apache:latest

# Pull bind image
echo "🔹 Pulling theb0ys/bind:latest"
docker pull theb0ys/bind:latest

# Pull dns64 image
echo "🔹 Pulling theb0ys/dns64:latest"
docker pull theb0ys/dns64:latest

# Pull oldap image
echo "🔹 Pulling theb0ys/oldap:latest"
docker pull theb0ys/oldap:latest

# Pull mariadb image
echo "🔹 Pulling theb0ys/mariadb:latest"
docker pull theb0ys/mariadb:latest

# Pull nat64 image
echo "🔹 Pulling theb0ys/nat64:latest"
docker pull theb0ys/nat64:latest

# Pull nginx image
echo "🔹 Pulling theb0ys/nginx:latest"
docker pull theb0ys/nginx:latest

# Pull samba image
echo "🔹 Pulling theb0ys/samba:latest"
docker pull theb0ys/samba:latest

# Pull red_hornet image
echo "🔹 Pulling theb0ys/red_hornet:latest"
docker pull theb0ys/red-hornet:latest

echo "✅ All pulls completed!"
