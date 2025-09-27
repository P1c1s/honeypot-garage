FROM theb0ys/base:latest

# Install TAYGA (NAT64 gateway)
RUN apt-get update && \
    apt-get install -y samba && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*