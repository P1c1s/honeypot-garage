# FROM kathara/base

# COPY .bashrc /root/.bashrc

# RUN apt-get update && apt-get install -y \
#     && apt-get clean


FROM alpine:3.15

RUN apk --update --no-cache add bind bind-dnssec-tools bash nano

COPY .bashrc /root/.bashrc

# Imposta bash come shell di default
CMD ["/bin/bash"]