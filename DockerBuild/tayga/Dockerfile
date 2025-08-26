FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

ARG TAYGA_IPV4_ADDR=192.0.2.1
ARG TAYGA_PREFIX=64:ff9b::/96
ARG TAYGA_POOL=192.0.2.0/24

RUN apt-get update && \
    apt-get install -y --no-install-recommends tayga iproute2 iptables procps && \
    rm -rf /var/lib/apt/lists/*

COPY start-tayga.sh /usr/local/bin/start-tayga.sh
COPY tayga.conf.template /etc/tayga.conf.template

RUN mkdir -p /var/run && chmod +x /usr/local/bin/start-tayga.sh

ENTRYPOINT ["/usr/local/bin/start-tayga.sh"]

HEALTHCHECK --interval=15s --timeout=3s --retries=3 \
  CMD ip link show nat64 >/dev/null 2>&1 || exit 1
