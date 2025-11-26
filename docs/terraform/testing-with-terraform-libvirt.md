---
title: "Testing Roles with Terraform and libvirt"
summary: "How to use the Terraform + libvirt VM testing infrastructure to validate Ansible roles that require full system access."
type: "how-to"
scope: "infra"
tags:
  - "terraform"
  - "libvirt"
  - "vm-testing"
  - "ansible"
related:
  - "INDEX.md"
  - "../troubleshooting/terraform-vm-testing.md"
  - "../../terraform/README.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-19"
canonical_url: "docs/terraform/testing-with-terraform-libvirt.md"
---

# Testing Roles with Terraform and libvirt

Some roles in this repository require full system access (for example disk partitioning, bootloader installation, or encrypted filesystems). For these cases, you should use the Terraform + libvirt VM testing infrastructure under `terraform/` instead of container-based Molecule tests.

This document is the canonical overview of that workflow. Detailed commands and scripts live in [`terraform/README.md`](../../terraform/README.md).

## When to use Terraform VM testing

Use Terraform + libvirt when:

- A role manipulates disks or partitions (for example the `arch_iso_install` role).
- A role installs or configures a bootloader.
- You need to verify full OS installation or early boot behavior.
- You require graphical access to the VM to inspect the installer or desktop.

For configuration-only roles (packages, services, simple networking), prefer Molecule + Docker instead.

## One-time host setup

From the project root:

```bash
cd terraform
./ubuntu-setup.sh
```

This script:

- Installs libvirt, KVM, `virt-manager`, and `virt-viewer`.
- Adds your user to the `libvirt` and `kvm` groups.
- Configures libvirt permissions and disables problematic AppArmor restrictions.
- Installs Terraform and verifies basic connectivity.

You **must** log out and back in after running the script so group membership takes effect.

See the “Quick Start” section in [`terraform/README.md`](../../terraform/README.md#quick-start) for full details.

## Creating and using a test VM

From the project root:

```bash
cd terraform
./vm-create.sh
```

The helper script will:

1. Initialize Terraform.
2. Download and cache the Arch Linux ISO.
3. Create a VM with default resources (2 GB RAM, 2 vCPUs, 5 GB disk).
4. Print connection information and suggested next steps.

To access the VM graphically:

```bash
virt-viewer --connect qemu:///system arch-test
# or
virt-manager
```

Use the graphical console to:

- Set the root password.
- Verify that the Arch installer or installed system boots correctly.
- Inspect services and logs when debugging roles.

## Running Ansible against the VM

Once the VM is created and reachable:

1. Ensure the VM’s IP address is recorded in `inventories/workstations/hosts.yml`.
2. Start the Docker development environment if you are using it.
3. Run the deployment playbook:

```bash
cd ..
sudo -E docker compose exec ansible-dev \
  ansible-playbook -i inventories/workstations/hosts.yml deploy.yml
```

You can restrict execution to specific roles using tags, as described in [`README.md`](../../README.md).

## Customizing VM resources

Default CPU, memory, and disk sizes are defined in `terraform/variables.tf`. To change them:

- Edit `variables.tf` directly, **or**
- Override via CLI:

```bash
cd terraform
terraform apply -var="memory_mb=4096" -var="vcpus=4" -auto-approve
```

Keep changes modest to avoid overcommitting your host.

## Cleaning up

When you are done with a test VM:

```bash
cd terraform
./vm-destroy.sh
```

This destroys the VM and associated resources but leaves the cached ISO and Terraform configuration intact so you can recreate environments quickly.

## Troubleshooting

For common failures (domain already exists, VM not booting, network or permission problems), use the dedicated runbook:

- [`docs/troubleshooting/terraform-vm-testing.md`](../troubleshooting/terraform-vm-testing.md)

That document provides command-level recipes using `virsh`, libvirt networks, and Terraform state cleanup.

## Source

This canonical overview is derived from the VM testing sections in [`terraform/README.md`](../../terraform/README.md:1) and the higher-level testing description in [`DEVELOPMENT.md`](../../DEVELOPMENT.md:87).