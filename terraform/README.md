# Terraform VM testing infrastructure

This directory provides Terraform configurations and helper scripts for VM-based testing of Ansible roles. Detailed documentation now lives under the canonical docs in `docs/`.

## Canonical documentation

For complete setup and usage instructions, see:

- [`docs/terraform/testing-with-terraform-libvirt.md`](../docs/terraform/testing-with-terraform-libvirt.md:1)
- [`docs/troubleshooting/terraform-vm-testing.md`](../docs/troubleshooting/terraform-vm-testing.md:1)
- [`docs/reference/testing-best-practices.md`](../docs/reference/testing-best-practices.md:1)

These docs cover:

- One-time Ubuntu/libvirt/KVM setup
- VM creation and destruction workflows
- Graphical access via virt-viewer and virt-manager
- Integration with Ansible playbooks and roles such as `arch_iso_install`
- Troubleshooting common Terraform/libvirt issues

## Files in this directory

Key files you will see here include:

- [`main.tf`](main.tf:1) – core Terraform configuration
- [`variables.tf`](variables.tf:1) – tunable inputs such as memory, CPU, and disk size
- [`outputs.tf`](outputs.tf:1) – connection and metadata outputs
- [`ubuntu-setup.sh`](ubuntu-setup.sh:1) – helper for initial environment setup on Ubuntu
- [`vm-create.sh`](vm-create.sh:1) – convenience wrapper for `terraform init` and `terraform apply`
- [`vm-destroy.sh`](vm-destroy.sh:1) – convenience wrapper for `terraform destroy`

Refer to the canonical docs linked above for the latest usage patterns and examples. This file remains a lightweight index to avoid duplicating content.