# Use an Alpine image with glibc already installed: https://github.com/Docker-Hub-frolvlad/docker-alpine-glibc/tree/master
FROM frolvlad/alpine-glibc:latest

# Set Architecture Compatibility
ARG GLIBC_ARCH=x86_64
# ARG GLIBC_ARCH=aarch64

# Mount /root vol for potential ssh keys or other user-specific configs
VOLUME ["/root"]

# Mount /data vol for project files
VOLUME ["/data"]
WORKDIR /data

# Update and Install Dependencies
RUN set -e \
    && apk --no-cache update  \
    && apk --no-cache add \
        bash \
        fish \
        binutils \
        bind-tools \
        curl \
        jq \
        groff \
        less \
        ca-certificates \
        openssl \
        unzip \
        wget \
        git \
        openssh-client \
        rsync \
        py3-pip \
        py3-dnspython \
        py3-jmespath \
        ansible \
        ansible-lint \
        docker-cli \
    && rm -rf /var/cache/apk/* /tmp/* \
    && pip3 install --no-cache-dir --break-system-packages \
        molecule>=5.0 \
        molecule-plugins[docker]>=23.0 \
        docker>=6.0

# Default command to bash shell
CMD [ "/bin/bash" ]
