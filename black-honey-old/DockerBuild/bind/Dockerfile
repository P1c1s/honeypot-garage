FROM theb0ys/base:latest

# Install BIND and DNS tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bind9 \
        bind9utils \
        bind9-dnsutils \
        dnsutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*