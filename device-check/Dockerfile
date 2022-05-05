FROM ubuntu:18.04

ENV NODE_VERSION node_8.x
ENV BALENA_CLI_VERSION 13.4.1
ENV DISTRO bionic
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /usr/src/local-device-debugger

RUN apt-get update && apt-get install -y apt-transport-https curl unzip gnupg2 ssh avahi-utils python && rm -rf /var/lib/apt/lists/*
RUN curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo "deb https://deb.nodesource.com/$NODE_VERSION $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src https://deb.nodesource.com/$NODE_VERSION $DISTRO main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install -y jq nodejs sudo && rm -rf /var/lib/apt/lists/* && \
    curl -sSL https://github.com/balena-io/balena-cli/releases/download/v$BALENA_CLI_VERSION/balena-cli-v$BALENA_CLI_VERSION-linux-x64-standalone.zip > balena-cli.zip && \
    unzip balena-cli.zip && mv balena-cli/* /usr/bin && rm -rf balena-cli.zip balena-cli

COPY ./debug.sh ./debug.sh
COPY ./microServer.py ./microServer.py
# Temp workaround for testing
COPY ./id_rsa_testing ./id_rsa_testing
CMD ["bash", "debug.sh"]
