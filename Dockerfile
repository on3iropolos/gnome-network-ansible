FROM alpine/ansible:latest

# Install only required additional tools (base image includes ansible + ansible-lint)
RUN apk --no-cache add \
    bash \
    git \
    openssh-client \
    docker-cli \
    py3-pip

# Install pre-commit for setup task
RUN pip3 install --no-cache-dir --break-system-packages pre-commit

WORKDIR /data

# Default command to bash shell
CMD ["/bin/bash"]
