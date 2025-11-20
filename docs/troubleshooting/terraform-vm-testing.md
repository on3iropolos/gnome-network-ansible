---
title: "Troubleshooting Terraform VM Testing with libvirt"
summary: "Runbook for diagnosing and fixing common issues when using the Terraform + libvirt VM testing infrastructure."
type: "runbook"
scope: "infra"
tags:
  - "terraform"
  - "libvirt"
  - "vm-testing"
  - "troubleshooting"
related:
  - "../terraform/INDEX.md"
  - "../troubleshooting/troubleshooting-molecule.md"
  - "../../terraform/README.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-19"
canonical_url: "docs/troubleshooting/terraform-vm-testing.md"
---

# Troubleshooting Terraform VM Testing with libvirt

This runbook covers common failures when using the Terraform + libvirt VM testing setup under `terraform/`. It complements the usage guide and reference details in [`terraform/README.md`](../../terraform/README.md:1).

## Prerequisites

Before troubleshooting, ensure that:

- You have run the one-time setup script from [`terraform/README.md`](../../terraform/README.md:18).
- You have logged out and back in so libvirt/kvm group membership is active.
- The host supports KVM and libvirt and you are on a supported Ubuntu-like system.

## Scenario 1: Domain already exists

**Symptom**

Terraform (or `vm-create.sh`) fails with a message like:

- `domain 'arch-test' already exists`
- Errors defining or starting the `arch-test` domain.

**Fix**

Use `virsh` to remove the stale domain:

```bash
virsh --connect qemu:///system undefine arch-test
# Or, if the domain has leftover storage attached:
virsh --connect qemu:///system undefine arch-test --remove-all-storage
```

Re-run the VM creation script:

```bash
cd terraform
./vm-create.sh
```

## Scenario 2: VM does not boot correctly

**Symptom**

- VM appears in `virsh list --all` but does not reach the Arch ISO boot menu.
- Graphical console is blank or shows boot failure.

**Checks**

```bash
sudo systemctl status libvirtd
kvm-ok || lsmod | grep kvm
virsh list --all
```

**Fix**

- Start libvirtd if it is not running.
- Verify KVM modules are loaded and, if needed, enable virtualization in BIOS/UEFI.
- Destroy and recreate the VM:

```bash
cd terraform
./vm-destroy.sh
./vm-create.sh
```

## Scenario 3: Cannot connect with virt-viewer

**Symptom**

- `virt-viewer` fails to open the VM console.
- No display appears, or connection errors are shown.

**Fix**

On the host:

```bash
sudo apt-get install virt-viewer
virt-manager  # as an alternative GUI
virsh list    # confirm the VM is running
```

Use the connection command printed by `./vm-create.sh`, or run:

```bash
virt-viewer --connect qemu:///system arch-test
```

## Scenario 4: Terraform state problems

**Symptom**

- Terraform refuses to apply or destroy.
- Errors about invalid or corrupt state.

**Fix**

Reinitialize a clean Terraform state:

```bash
cd terraform
rm -f terraform.tfstate terraform.tfstate.backup
terraform init
```

Recreate the VM with the helper script or `terraform apply`.

## Scenario 5: Network issues

**Symptom**

- VM has no network.
- `ansible` cannot reach the VM by IP.

**Checks**

```bash
virsh net-list
virsh net-dumpxml default
```

**Fix**

Ensure the default libvirt network is running and enabled:

```bash
virsh net-start default
virsh net-autostart default
```

Inside the VM, verify that an IP address is assigned and that outbound connectivity works.

## Scenario 6: Permission problems (libvirt/AppArmor/groups)

**Symptom**

- Terraform or helper scripts fail with permission errors.
- Libvirt socket access denied.

**Fix**

On the host:

```bash
# AppArmor should not restrict libvirtd:
sudo aa-status | grep libvirtd

# Confirm group membership:
groups | grep -E 'libvirt|kvm'
```

If required groups are missing, add your user and then log out and back in:

```bash
sudo usermod -aG libvirt,kvm "$USER"
```

Restart libvirtd if it was modified or reconfigured.

## Verification

After applying fixes:

1. `terraform apply` or `./vm-create.sh` completes without error.
2. The VM appears as running in `virsh list`.
3. You can open a graphical console with `virt-viewer` or `virt-manager`.
4. Ansible can connect to the VM using the inventory entry in `inventories/workstations/hosts.yml`.

If problems persist, capture:

- `terraform` logs or terminal output.
- `virsh list --all` and `virsh net-list`.
- Any error messages from `virt-viewer` or `virt-manager`.

These details will help refine this runbook and future troubleshooting docs.