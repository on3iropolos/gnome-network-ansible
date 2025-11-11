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

# Create VM with default (quick-test) scenario
./vm-create.sh

# Or specify a scenario
./vm-create.sh full-test

# Or with custom test ID
./vm-create.sh quick-test my-custom-id
```

The script will:
1. Initialize Terraform
2. Download the Arch Linux ISO (cached for future use)
3. Create a VM with the specified resources
4. Display connection information
5. Optionally open virt-viewer GUI

### 3. Access the VM Graphically

**Option A: Using virt-viewer (Recommended)**
```bash
# Command will be shown after VM creation
virt-viewer --connect qemu:///system arch-test-<test_id>
```

**Option B: Using virt-manager**
```bash
# Launch virt-manager
virt-manager

# Find your VM in the list (e.g., "arch-test-quick")
# Double-click to open the graphical console
```

### 4. Prepare VM for Ansible

In the VM console (Arch ISO environment):
```bash
# Set root password (use same as SSH_PASSWORD env var)
passwd

# Start SSH server
systemctl start sshd

# Find IP address
ip a
# Look for IP on ens3 or similar interface
```

### 5. Run Ansible Roles

Update your inventory with the VM IP:
```yaml
# Example: inventories/test/hosts.yml
all:
  hosts:
    test_vm:
      ansible_host: <VM_IP_ADDRESS>
      ansible_user: root
      ansible_ssh_pass: "{{ lookup('env', 'SSH_PASSWORD') }}"
      ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
```

Run your playbooks (see [`../README.md#running-playbooks`](../README.md#running-playbooks) for environment variable details):
```bash
# Run playbook against your VM
ansible-playbook -i inventories/test/hosts.yml deploy.yml
```

### 6. Clean Up

```bash
# Destroy the VM
./vm-destroy.sh <test_id>

# Examples:
./vm-destroy.sh quick
./vm-destroy.sh my-custom-id
```

## Available Scenarios

Scenarios are defined in the `scenarios/` directory:

### quick-test (Default)
- **Memory:** 2GB
- **CPUs:** 2
- **Disk:** 10GB
- **Use case:** Quick testing, minimal resources, fast iteration

### full-test
- **Memory:** 4GB
- **CPUs:** 4
- **Disk:** 30GB
- **Use case:** Production-like testing, full feature validation

## Creating Custom Scenarios

Create a new `.tfvars` file in `scenarios/`:

```hcl
# scenarios/custom-scenario.tfvars
test_id         = "custom"
memory_mb       = 8192
vcpus           = 4
disk_size_bytes = 53687091200  # 50GB
```

Use it:
```bash
./vm-create.sh custom-scenario my-id
```

## Manual Terraform Usage

If you prefer direct Terraform commands:

```bash
# Initialize
terraform init

# Plan with a scenario
terraform plan -var="test_id=mytest" -var-file="scenarios/quick-test.tfvars"

# Apply
terraform apply -var="test_id=mytest" -var-file="scenarios/quick-test.tfvars" -auto-approve

# View outputs
terraform output

# Destroy
terraform destroy -var="test_id=mytest" -auto-approve
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
├── scenarios/           # Pre-defined test scenarios
│   ├── quick-test.tfvars
│   └── full-test.tfvars
└── README.md           # This file
```

## Integration with Roles

### Testing arch_iso_install Role

```bash
# Create VM
cd terraform
./vm-create.sh quick-test arch-install-test

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
virsh --connect qemu:///system undefine arch-test-<test_id>

# Or remove all test domains
virsh --connect qemu:///system list --all | grep arch-test | awk '{print $2}' | \
    xargs -I {} virsh --connect qemu:///system undefine {}
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
2. **Multiple VMs**: Use different test_id values to run multiple VMs simultaneously
3. **Snapshots**: Use virt-manager to create snapshots before major operations
4. **Performance**: VMs use host CPU passthrough for best performance
5. **Resource Cleanup**: Always destroy VMs when done to free system resources

## See Also

- [Project README](../README.md)
- [Development Guide](../DEVELOPMENT.md)
- [arch_iso_install Role](../roles/arch_iso_install/README.md)
- [Terraform libvirt Provider](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs)