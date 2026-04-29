FROM alpine/ansible:latest

# Install only required additional tools (base image includes ansible + ansible-lint)
RUN apk --no-cache add \
    bash \
    git \
    openssh-client \
    docker-cli

WORKDIR /data

# Default command to bash shell
CMD ["/bin/bash"]
