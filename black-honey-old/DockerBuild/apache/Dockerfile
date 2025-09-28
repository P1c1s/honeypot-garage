FROM theb0ys/base:latest

# Update, upgrade, and install packages
RUN apt update && \
    apt install -y --no-install-recommends \
        apache2 \
        php \
        libapache2-mod-php \
        php-mysql \
		mariadb-server && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
