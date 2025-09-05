FROM kathara/base

ENV \
	TAYGA_CONF_DATA_DIR=/var/db/tayga \
	TAYGA_CONF_DIR=/usr/local/etc

COPY .bashrc /root/.bashrc

RUN apt-get update && apt-get install -y \
    tayga \
    && apt-get clean