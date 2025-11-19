# Use the official Alpine Linux base image
FROM alpine:latest

# Set Architecture and glibc version
# Using an ARG for glibc_version allows for easier updates in the future.
ARG GLIBC_VERSION=2.35-r1
ARG GLIBC_ARCH=x86_64

# Install glibc on Alpine
# This is a common pattern to add glibc compatibility to Alpine for software that needs it.
# It downloads the glibc package from a trusted community repository (sgerrand/alpine-pkg-glibc).
RUN set -e \
    && apk --no-cache add ca-certificates wget \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && apk add --no-cache glibc-${GLIBC_VERSION}.apk \
    && rm glibc-${GLIBC_VERSION}.apk

# Mount /root vol for potential ssh keys or other user-specific configs
VOLUME ["/root"]

# Mount /data vol for project files
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
        libvirt-client \
    && rm -rf /var/cache/apk/* /tmp/* \
    && pip3 install --no-cache-dir --break-system-packages \
        molecule \
        molecule-plugins[docker] \
        docker

# Add libvirt group for virsh socket communication
# Use the same GID as host system's libvirt group (128)
# This allows proper communication with the host libvirt daemon via mounted socket
RUN addgroup -g 128 libvirt 2>/dev/null || true \
    && addgroup root libvirt 2>/dev/null || true

# Default command to bash shell
CMD ["/bin/bash"]
