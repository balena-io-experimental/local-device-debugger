FROM debian:buster-slim

#ENV NODE_VERSION node_8.x
ENV BALENA_CLI_VERSION 13.4.1
#ENV DISTRO bionic
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /usr/src/local-device-debugger

RUN apt-get update && apt-get install -y apt-transport-https curl unzip gnupg2 ssh avahi-daemon avahi-utils libnss-mdns python sudo && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - && \
    apt-get update && apt-get install -y jq nodejs && rm -rf /var/lib/apt/lists/* && \
    curl -sSL https://github.com/balena-io/balena-cli/releases/download/v$BALENA_CLI_VERSION/balena-cli-v$BALENA_CLI_VERSION-linux-x64-standalone.zip > balena-cli.zip && \
    unzip balena-cli.zip && mv balena-cli/* /usr/bin && rm -rf balena-cli.zip balena-cli

RUN echo '*' > /etc/mdns.allow \
    # Configure NSSwitch to use the mdns4 plugin so mdns.allow is respected
    && sed -i "s/hosts:.*/hosts:          files mdns4 dns/g" /etc/nsswitch.conf \
    && chmod 777 /etc/avahi/avahi-daemon.conf \
    && mkdir -p /var/run/avahi-daemon \
    && chown avahi:avahi /var/run/avahi-daemon \
    && chmod 777 /var/run/avahi-daemon

COPY ./debug.sh ./debug.sh
COPY ./microServer.py ./microServer.py
# Temp workaround for testing
COPY ./id_rsa_testing ./id_rsa_testing
CMD ["bash", "debug.sh"]
