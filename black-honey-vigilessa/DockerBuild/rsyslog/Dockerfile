FROM theb0ys/base:latest

# Install -..-
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      apache2 \
      php \
      libapache2-mod-php \
      php-mysql \
		  mariadb-server \
      rsyslog-mysql && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*