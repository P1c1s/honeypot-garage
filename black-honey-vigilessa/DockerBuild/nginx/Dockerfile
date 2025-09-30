FROM theb0ys/base:latest

# Install TAYGA (NAT64 gateway)
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*