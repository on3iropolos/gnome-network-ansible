#!/bin/bash
set -e
set -x

# This script is now a minimal bootstrap to enable Packer to connect via SSH
# and run the Ansible provisioner. The actual installation logic has moved
# to the 'install.yml' Ansible playbook.

PASSWORD="${2:-vagrant}"

echo "Bootstrapping Arch Linux Live ISO for Packer..."

# Set root password for the Live environment
echo "root:${PASSWORD}" | chpasswd

# Configure SSH to allow root login
sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Ensure python and ansible are available
# if ! command -v ansible-playbook &> /dev/null; then
#   echo "installing python and ansible..."
#   pacman -Sy --noconfirm python ansible
# fi

# Ensure sshd is running
systemctl start sshd

# Unlock root account if locked
passwd -u root

echo "Bootstrap complete. Ready for Ansible."
