# Use the official Alpine Linux base image
FROM alpine:latest

ARG GLIBC_VERSION=2.35-r1
ARG GLIBC_ARCH=x86_64

RUN set -e \
    && apk --no-cache add ca-certificates wget \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && apk add --no-cache glibc-${GLIBC_VERSION}.apk \
    && rm glibc-${GLIBC_VERSION}.apk

VOLUME ["/root"]
VOLUME ["/data"]
WORKDIR /data

# Update and Install Dependencies
RUN set -e \
    && apk --no-cache update \
    && apk --no-cache add \
        bash \
        fish \
        binutils \
        bind-tools \
        curl \
        jq \
        groff \
        less \
        openssl \
        unzip \
        git \
        openssh-client \
        sshpass \
        rsync \
        py3-pip \
        py3-dnspython \
        py3-jmespath \
        ansible \
        ansible-lint \
        docker-cli \
    && rm -rf /var/cache/apk/* /tmp/* \
    && pip3 install --no-cache-dir --break-system-packages \
        molecule \
        molecule-plugins[docker] \
        docker

# Default command to bash shell
CMD ["/bin/bash"]
