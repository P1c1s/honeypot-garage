FROM theb0ys/base:latest

# Install -..-
RUN apt-get update && \
    apt-get install -y --no-install-recommends suricata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN curl -L https://raw.githubusercontent.com/netdata/netdata/master/packaging/installer/kickstart.sh | bash

