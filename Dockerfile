FROM alpine:latest
MAINTAINER Mats Bergmann <bateau@sea-shell.org>

ARG OPENTTD_VERSION="1.10.2-r0"
ARG OPENGFX_VERSION="0.6.0-r0"

ADD --chown=1000:1000 openttd.sh /openttd.sh

RUN apk add dumb-init --no-cache && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add openttd=${OPENTTD_VERSION} openttd-opengfx=${OPENGFX_VERSION} --no-cache && \
    adduser --disabled-password --uid 1000 --shell /bin/sh --gecos "" openttd && \
    addgroup openttd users && \
    chmod +x /openttd.sh

VOLUME /home/openttd/.openttd

EXPOSE 3979/tcp
EXPOSE 3979/udp

STOPSIGNAL 3
ENTRYPOINT [ "/usr/bin/dumb-init", "--rewrite", "15:3", "--rewrite", "9:3", "--" ]
CMD [ "/openttd.sh" ]
