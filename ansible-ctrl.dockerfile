# Use an Alpine image with glibc already installed: https://github.com/Docker-Hub-frolvlad/docker-alpine-glibc/tree/master
FROM frolvlad/alpine-glibc:latest

# ENV AWS_CLI_VERSION=1.16.313
ENV AWS_CLI_VERSION=2.10.0
ENV PROVIDER=aws
# Set Architecture Compatibility
ARG GLIBC_ARCH=x86_64
# ARG GLIBC_ARCH=aarch64

# Mount /root vol to access ./.aws profiles and configuration
VOLUME ["/root"]

# Mount /data vol
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
        aws-cli \
        py3-pip \
        py3-botocore \
        py3-boto3 \
        py3-dnspython \
        py3-jmespath \
        ansible \
        ansible-lint \
    && rm -rf /var/cache/apk/* /tmp/*

# Try out fish shell
CMD [ "/bin/bash" ]