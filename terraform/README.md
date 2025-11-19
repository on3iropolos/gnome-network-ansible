# Terraform VM Testing Infrastructure

This directory contains Terraform configurations for creating test VMs used to validate Ansible roles across the Gnome Network infrastructure.

## Overview

The Terraform setup creates KVM/libvirt virtual machines with:
- Arch Linux ISO attached as a bootable CD-ROM
- A blank disk for installation testing
- Network connectivity via default libvirt network
- SPICE graphics for GUI access via virt-viewer or virt-manager

These VMs are used to test roles like:
- `arch_iso_install` - Arch Linux installation automation
- `network` - Network configuration
- Any other roles requiring full VM environments

## Quick Start

### 1. One-Time Setup (Run once on fresh Ubuntu system)

```bash
# Run the automated setup script
cd terraform
./ubuntu-setup.sh
```

This script will:
- Install libvirt, KVM, virt-manager, virt-viewer
- Add your user to libvirt/kvm groups
- Configure libvirt for proper permissions
- Disable AppArmor for libvirtd (required for VM disk access)
- Install Terraform
- Verify all components

**Important:** Log out and back in after setup for group changes to take effect.

### 2. Create a Test VM

```bash
# From the project root
cd terraform

# Create VM with default configuration
./vm-create.sh
```

The script will:
1. Initialize Terraform
2. Download the Arch Linux ISO (cached for future use)
3. Create a VM with the configured resources
4. Display connection information and next steps

Default VM Configuration:
- **Memory:** 2GB
- **CPUs:** 2
- **Disk:** 5GB

### 3. Access the VM Graphically

**Option A: Using virt-viewer (Recommended)**
```bash
# Command will be shown after VM creation
virt-viewer --connect qemu:///system arch-test
```

**Option B: Using virt-manager**
```bash
# Launch virt-manager
virt-manager

# Find your VM in the list ("arch-test")
# Double-click to open the graphical console
```

### 4. Set Root Password in VM

```bash
virt-viewer --connect qemu:///system arch-test
# Login as root, then: passwd
```

### 5. Run Ansible

```bash
# From project root
cd ..
sudo -E docker compose exec ansible-dev \
  ansible-playbook -i inventories/workstations/hosts.yml deploy.yml
```

### 6. Clean Up

```bash
# Destroy the VM
./vm-destroy.sh
```

## Customizing VM Configuration

To adjust VM resources, modify the default values in `variables.tf`:

```hcl
# variables.tf
variable "memory_mb" {
  description = "Memory allocation in MB"
  type        = number
  default     = 2048  # Change this value
}

variable "vcpus" {
  description = "Number of virtual CPUs"
  type        = number
  default     = 2  # Change this value
}

variable "disk_size_bytes" {
  description = "Installation disk size in bytes"
  type        = number
  default     = 5368709120  # 5GB - Change this value
}
```

Or override via command line:
```bash
terraform apply -var="memory_mb=4096" -var="vcpus=4" -auto-approve
```

## Manual Terraform Commands

```bash
terraform init
terraform apply -auto-approve
terraform output
terraform destroy -auto-approve
```

## Troubleshooting

### Domain Already Exists Error

**Symptom:**
```
error defining libvirt domain: operation failed: domain 'arch-test-X' already exists
```

**Fix:**
```bash
# Remove the existing domain
virsh --connect qemu:///system undefine arch-test

# Or force undefine if needed
virsh --connect qemu:///system undefine arch-test --remove-all-storage
```

### VM Doesn't Boot
- Check libvirtd: `sudo systemctl status libvirtd`
- Verify KVM: `kvm-ok` or `lsmod | grep kvm`
- Check VM status: `virsh list --all`

### Can't Connect with virt-viewer
- Ensure virt-viewer is installed: `sudo apt-get install virt-viewer`
- Try virt-manager as alternative: `virt-manager`
- Verify VM is running: `virsh list`

### Terraform State Issues

If Terraform state becomes corrupted:
```bash
# Clean state and start fresh
cd terraform
rm -f terraform.tfstate terraform.tfstate.backup
terraform init
```

### Network Issues
```bash
# Check default network
virsh net-list

# Start if needed
virsh net-start default
virsh net-autostart default
```

### Permission Issues

If you encounter permission errors:
```bash
# Verify AppArmor disabled
sudo aa-status | grep libvirtd  # Should show no output

# Verify group membership
groups | grep -E 'libvirt|kvm'  # Log out and back in if missing
```

## See Also

- [Project README](../README.md)
- [Development Guide](../DEVELOPMENT.md)
- [arch_iso_install Role](../roles/arch_iso_install/README.md)
- [Terraform libvirt Provider](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs)