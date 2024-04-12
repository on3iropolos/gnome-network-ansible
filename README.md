# About

This is the Gnome Network Ansible project in order to manage and deploy systems within Gnome Network infrastructure.

# Installation

## Pre-requisites

In order to deploy the Ansible controller container, you need to install [Docker](https://www.docker.com/).

## Installation

1. Ensure your processor architecture `ARG GLIBC_ARCH` is set in `ansible-ctrl.dockerfile`.
2. Run the appropriate script based on your operating system:

    - Mac/Lin: `bash install.sh`
    - Win: `powershell .\install.ps1`

3. Connect to your docker: `docker exec -it $(docker ps -f name=ansible-ctrl -q) fish`

## Host Initialization

1. Boot the host and run the following commands:

    - `passwd` (same as `SSH_PASSWORD`)
    - `systemctl start sshd`
    - `ip a`

2. Update the the inventory `hosts.yml` file to include the IP address assigned by DHCP.

## Inventory Deployment

1. Set environment variables:

    - `export SSH_PASSWORD="my value"`
    - `export ENCRYPTION_PASSWORD="my value"`
    - `export USER_PASSWORD="my value"`

2. Run the ansible playbook: `ansible-playbook -i /data/inventories/workstations/ deploy.yml`
