FROM theb0ys/base:latest

# Install TAYGA (NAT64 gateway)
RUN apt-get update && \
    apt-get install -y tayga nginx nginx-extras && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# nginx-extras add module stream for vnc 5900