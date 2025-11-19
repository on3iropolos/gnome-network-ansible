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

### 4. Prepare VM for Ansible

Open the VM console and set root password:

```bash
# Open VM graphically
virt-viewer --connect qemu:///system arch-test

# In the VM console:
# 1. Login as root (press Enter at login prompt, type 'root')
# 2. Set password to match SSH_PASSWORD from your .env file:
passwd
```

**That's it!** SSH is already running on Arch ISO by default.

### 5. Run Ansible Playbooks

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

## Manual Terraform Usage

If you prefer direct Terraform commands:

```bash
# Initialize
terraform init

# Plan
terraform plan

# Apply
terraform apply -auto-approve

# View outputs
terraform output

# Destroy
terraform destroy -auto-approve
```

## File Structure

```
terraform/
├── main.tf              # Main Terraform configuration
├── variables.tf         # Variable definitions
├── outputs.tf           # Output definitions
├── ubuntu-setup.sh      # Automated Ubuntu environment setup
├── vm-create.sh         # Helper script to create VMs
├── vm-destroy.sh        # Helper script to destroy VMs
└── README.md           # This file
```

## Integration with Roles

### Testing arch_iso_install Role

```bash
# Create VM
cd terraform
./vm-create.sh

# In VM console: set passwd, start sshd, get IP

# Run arch_iso_install role
cd ..
ansible-playbook -i inventories/test/hosts.yml deploy.yml \
    --tags arch_iso_install
```

### Testing Other Roles

The same VM can be used to test multiple roles sequentially:

```bash
# After arch_iso_install completes and system reboots:

# Test network role
ansible-playbook -i inventories/test/hosts.yml deploy.yml \
    --tags network

# Test additional roles
ansible-playbook -i inventories/test/hosts.yml deploy.yml \
    --tags other_role
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

### Permission Issues After Setup

If you encounter permission errors after running the setup script:

1. **Verify AppArmor is disabled for libvirtd:**
   ```bash
   sudo aa-status | grep libvirtd
   # Should show NO output (not confined)
   ```

2. **If still confined, manually disable:**
   ```bash
   sudo ln -sf /etc/apparmor.d/usr.sbin.libvirtd /etc/apparmor.d/disable/
   sudo apparmor_parser -R /etc/apparmor.d/usr.sbin.libvirtd
   sudo systemctl restart libvirtd
   ```

3. **Verify group membership:**
   ```bash
   groups | grep -E 'libvirt|kvm'
   # If not present, log out and back in
   ```

### Re-enabling AppArmor for libvirtd

If you need to re-enable AppArmor protection later:
```bash
sudo rm /etc/apparmor.d/disable/usr.sbin.libvirtd
sudo apparmor_parser -a /etc/apparmor.d/usr.sbin.libvirtd
sudo systemctl restart libvirtd
```

## Tips

1. **ISO Caching**: The Arch ISO is downloaded once and cached in libvirt storage pool
2. **Snapshots**: Use virt-manager to create snapshots before major operations
3. **Performance**: VMs use host CPU passthrough for best performance
4. **Resource Cleanup**: Always destroy VMs when done to free system resources
5. **Customization**: Adjust default values in `variables.tf` for different resource requirements

## See Also

- [Project README](../README.md)
- [Development Guide](../DEVELOPMENT.md)
- [arch_iso_install Role](../roles/arch_iso_install/README.md)
- [Terraform libvirt Provider](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs)