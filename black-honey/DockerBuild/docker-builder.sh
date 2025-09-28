#!/bin/bash

# Build base image
echo "🔹 Building theb0ys/base:latest"
docker build -t theb0ys/base:latest base

# Build apache image
echo "🔹 Building theb0ys/apache:latest"
docker build -t theb0ys/apache:latest apache

# Build bind image
echo "🔹 Building theb0ys/bind:latest"
docker build -t theb0ys/bind:latest bind

# Build dns64 image
echo "🔹 Building theb0ys/dns64:latest"
docker build -t theb0ys/dns64:latest dns64

# Build oldap image
echo "🔹 Building theb0ys/oldap:latest"
docker build -t theb0ys/oldap:latest oldap

# Build mariadb image
echo "🔹 Building theb0ys/mariadb:latest"
docker build -t theb0ys/mariadb:latest mariadb

# Build nat64 image
echo "🔹 Building theb0ys/nginx:latest"
docker build -t theb0ys/nat64:latest nat64

# Build nginx image
echo "🔹 Building theb0ys/nginx:latest"
docker build -t theb0ys/nginx:latest nginx

# Build samba image
echo "🔹 Building theb0ys/samba:latest"
docker build -t theb0ys/samba:latest samba

# Build red_hornet image
echo "🔹 Building red_hornet:latest"
docker build -t theb0ys/red-hornet red-hornet

# Build ubuntu-desktop image
echo "🔹 Building ubuntu-desktop:latest"
docker build -t theb0ys/ubuntu-desktop ubuntu-desktop

echo "✅ All builds completed!"
