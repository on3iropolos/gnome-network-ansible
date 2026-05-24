---
title: "Testing Ansible Deployment with VMs"
summary: "Using the vm_host role to create and manage libvirt VMs, then provision them with provision-vm.yml."
type: "how-to"
scope: "repo"
tags:
  - "vm"
  - "testing"
  - "libvirt"
  - "provisioning"
  - "cloud-image"
related:
  - "../../roles/vm_host/defaults/main.yml"
  - "../../inventories/host_vars/whimsyforge.gnome.network.yml"
  - "../../provision.yml"
  - "../../provision-vm.yml"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2026-05-24"
canonical_url: "docs/how-to/vm-testing.md"
---

# Testing Ansible Deployment with VMs

The `vm_host` role manages libvirt-based VMs on `whimsyforge.gnome.network`.
It replaces the former `qemu` role and adds full VM lifecycle management using
Arch Linux cloud images.

## Prerequisites

- `whimsyforge.gnome.network` is your VM host (defined in inventory)
- KVM support on the host (check with `kvm-ok` or `ls /dev/kvm`)
- ~10 GB free disk per VM (for cloud image + overlay + seed ISO)

## VM Definitions

VMs are defined in `inventories/host_vars/whimsyforge.gnome.network.yml`:

```yaml
vm_host_vms:
  - name: test-arch-01
    state: running           # running | stopped | absent
    vcpus: 4
    memory_mb: 8192
    disk_gb: 40
    os_variant: archlinux
    cloud_image_url: "https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2"
```

The default user in the Arch cloud image is `arch` with passwordless sudo.
The role injects your SSH public key via cloud-init.

## Managing VMs

### Create or ensure VMs are running

```bash
mise run provision-playbook
```

The `vm_host` role (in `provision.yml`) manages the VM lifecycle on the host.
Once the VM is created, provision it with the dedicated playbook:

```bash
mise run provision-vm-playbook
```

Both roles are idempotent — running them again skips already-completed work.

### Destroy a VM

Change the VM's state to `absent` in `host_vars`, then run the playbook:

```yaml
vm_host_vms:
  - name: test-arch-01
    state: absent
```

```bash
mise run provision-playbook
```

Or pass the change via `-e`:

```bash
ansible-playbook provision.yml \
  -e '{"vm_host_vms":[{"name":"test-arch-01","state":"absent"}]}' \
  --tags vm_host
```

## Provisioning a VM with provision-vm.yml

Once the VM is running, the recommended way to provision it is with the
dedicated `provision-vm.yml` playbook, which targets the `test_vms` group:

```bash
mise run provision-vm-playbook
```

This applies a curated set of roles appropriate for VMs: `firewall`, `time`,
`locale`, `hosts`, `network`, `sshd`, `user`, `ssh_client`, `git`,
`github_cli`, `bitwarden`, `obsidian`, `opencode`, `gnome`.

Roles that require workstation-specific setup (`docker`, `kubernetes`,
`ollama`, `vm_host`) and roles blocked on known issues
(`dev-workspace` [#97][], `aur`/`spotify`/`vscodium`/`brave` [#98][]) are
excluded.

[#97]: https://github.com/on3iropolos/gnome-network-ansible/issues/97
[#98]: https://github.com/on3iropolos/gnome-network-ansible/issues/98

## Testing provision.yml Against a VM

To test the full workstation provisioning playbook on a VM instead:

```bash
# 1. Find the VM's IP address
virsh -c qemu:///system domifaddr test-arch-01

# 2. Run provision.yml against the VM
ansible-playbook -i <VM_IP>, -u arch --ask-become-pass provision.yml
```

### Notes

- The `arch` user has passwordless sudo, but Ansible's `become` still asks for
  a password by default. If you want to skip the prompt, pass `-e ansible_become_password=` 
  or configure `ansible_become_method: sudo` with `ansible_become_flags: '-S'` 
  in a host var.
- Some roles (e.g. `gnome`, `vm_host`) are conditional on `whimsyforge.gnome.network`
  and will not apply to the VM. This is expected.
- The cloud image is minimal — roles that install AUR packages (`aur`, `spotify`,
  `vscodium`, `brave`) will build packages from source, which takes time.

## Architecture

```
┌─────────────────────────────────────┐
│  whimsyforge.gnome.network          │
│                                     │
│  ┌──────────┐  ┌─────────────────┐  │
│  │ libvirtd │  │ VM:             │  │
│  │          │  │ test-arch-01    │  │
│  │ NAT      │◄─┤ arch user       │  │
│  │ network  │  │ cloud image     │  │
│  │ default  │  │ overlay disk    │  │
│  └──────────┘  └─────────────────┘  │
│         ▲              ▲            │
│         │              │            │
│  provision.yml   provision-vm.yml   │
│  (lifecycle)     (configuration)    │
└─────────────────────────────────────┘
```
