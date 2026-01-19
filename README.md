# Gnome Network Ansible

A project to automate the provisioning and configuration of Arch Linux workstations and servers using Ansible and Packer.

## Overview
This repository contains:
*   **Roles**: Modular Ansible roles for partitions, encryption, system configuration, and desktop environments.
*   **Packer**: Templates for building reproducible Arch Linux VM images.
*   **Terraform**: Infrastructure code (optional/WIP) for deploying these images.

## Current Status
> [!NOTE]
> **Encryption (LUKS)** is currently **disabled** in `packer_install.yml` to troubleshoot partitioning reliability and ISO disk space constraints. Re-enabling encryption is a high-priority task.

## Structure
*   `roles/`: Contains all granular roles.
    *   `partition`, `encryption`, `filesystem`: Storage stack.
    *   `pacstrap`: Base system installation.
    *   `time`, `locale`, `hosts`, `network`, `ssh`: System configuration.
    *   `user`: User management.
    *   `gnome`: GNOME Desktop Environment.
*   `packer/`: Packer templates.
    *   `packer.pkr.hcl`: Main build definition.
    *   `http/install.sh`: Bootstrap script for Live ISO.
*   `packer_install.yml`: Playbook for **Installing** the OS (run against Live ISO).
*   `packer_provision.yml`: Playbook for **Configuring** the OS (run inside the installed system).

## Workflow

### 1. Build Image (Packer)
The Packer build process consists of two stages:

1.  **Boot & Bootstrap**:
    *   Boots the official Arch Linux ISO.
    *   Runs `install.sh` to set a root password and enable SSH.
2.  **Installation (Ansible Remote)**:
    *   Packer runs `packer_install.yml` from the host.
    *   This playbook wipes `/dev/sda`, creates partitions (BTRFS/LUKS), installs `base`, and configures the bootloader (GRUB).
3.  **Configuration (Ansible Chroot)**:
    *   Packer uploads `packer_provision.yml` and roles to the new system mounted at `/mnt`.
    *   Runs `ansible-playbook` inside `arch-chroot /mnt`.
    *   Configures GNOME, NetworkManager, etc.

```bash
cd packer
packer init .
packer build packer.pkr.hcl
```

## Configuration & Secrets
To keep the build environment secure, variables are split between two files in the `packer/` directory:

1.  **`vars.auto.pkrvars.hcl`**: Contains non-sensitive values (ISO URLs, checksums). This file **is** tracked in Git.
2.  **`secrets.auto.pkrvars.hcl`**: Contains sensitive values (passwords, SSH public keys). This file **is ignored** by Git.

> [!TIP]
> Use the `.example` files provided in the `packer/` directory as templates for your local configuration.

## Development Guidelines

### 1. Modular Roles
Maintain the "one role, one responsibility" principle. If a role grows too large (e.g., does both partitioning AND installing software), break it down.

### 2. Naming Conventions
*   **Variables/Groups**: Use `snake_case` (e.g., `user_password`, `os_archlinux`).
*   **Tasks**: Use descriptive, sentence-case names starting with an action verb (e.g., `"Ensure sshd is enabled"`, `"Install base system"`).

### 3. Documentation
*   Maintain the `README.md` in each role's directory.
*   Update the main `AUDIT_LOG.md` when resolving or identifying new issues.
