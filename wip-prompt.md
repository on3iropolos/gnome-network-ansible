# Project Status: Unified Arch Linux Provisioning

## Executive Summary
This project is transitioning from environment-specific Packer scripts to a **Single Source of Truth** architecture using Ansible. The goal is to ensure that whether you are building a Hyper-V image or provisioning a physical workstation (e.g., `whimsyforge`), the business logic (roles, configurations, security policies) is identical and managed via a unified inventory.

## 1. Architectural Evolution: The "Purist" Pivot

### Phase 1: Path-Aware Roles (Previous Attempt)
Initially, we attempted to make roles "smart" by using an `install_root` variable (e.g., `/mnt`) and prefixing every path and command (e.g., `{{ install_root }}/etc/hostname` or `arch-chroot {{ install_root }} useradd`).
- **Failure Analysis**: This approach was "noisy," forced us to rewrite standard Ansible modules using `shell`, and created a fragile dependency on the `arch-chroot` binary being available in the exact right path on the Live ISO. It led to the `[Errno 2] No such file or directory` errors.

### Phase 2: Chroot Connection Plugin (Current Design)
We have pivoted to a "Purist" design where Ansible roles are written as if they are running on a live, native system (e.g., targeting `/etc/hosts` directly).
- **The Mechanic**: In Packer, the `provision.yml` playbook is executed using the `-c chroot` connection plugin. 
- **The Result**: Ansible "enters" the installed system at `/mnt`. Inside this context, `/` is the root of the new disk. Roles remain simple, standard, and 100% portable.
- **Parity**: The exact same `user` role now works during a Packer build (via chroot) and on a bare-metal machine (via local or SSH connection).

---

## 2. Bootstrapping Lifecycle

### Stage A: Live ISO Bootstrap (`install.sh`)
A minimal shell script that does only three things:
1.  Sets a temporary root password.
2.  Enables SSH for Packer/Ansible access.
3.  Ensures the environment is "Ansible-ready."

### Stage B: OS Deployment (`install.yml`)
Runs on the Live ISO, targeting `/dev/sda` (VM) or `/dev/nvme0n1` (Physical).
- **Roles**: Partitioning, Encryption (LUKS), Filesystem (BTRFS), and `pacstrap`.
- **Exit State**: The disk is formatted, the base OS is installed, and partitions are mounted at `/mnt`.

### Stage C: System Provisioning (`provision.yml`)
The "Flavoring" stage. Runs inside the system (chroot for VM, direct for Physical).
- **Roles**: `time`, `locale`, `hosts`, `network`, `ssh`, `user`, and `gnome`.
- **Parity Check**: Uses the same roles and code for both image creation and bare-metal.

---

## 3. Inventory Design & Variable Resolution

We use a directory-based inventory structure to separate environment data from logic.

### Hierarchy:
```text
inventories/
├── packer/                 # For Hyper-V Image Builds
│   ├── hosts               # Defines 'localhost' as the target
│   └── group_vars/all.yml  # VM-specific (e.g., install_drive: /dev/sda)
└── workstations/           # For Bare-Metal / Local Installs
    ├── hosts               # Target machines (e.g., whimsyforge)
    └── group_vars/all.yml  # Real hardware (e.g., gpu_type: amd)
```

### Variable Inheritance:
Roles use standard variable names (e.g., `{{ hostname }}`). Ansible resolves these by looking at the specific inventory passed via the `-i` flag. This eliminates hardcoding and allows us to change the entire build target by just switching the inventory directory.

---

## 4. Current Critical Path (The "Why" of the last failure)

### The "No Space Left" Error
During the last Packer run, the build failed with `No space left on device`.
- **Root Cause**: The Packer source was set to `../` (the project root). Packer tried to `scp` the entire repository into the Live ISO's RAM-based scratch space (`/run/archiso/cowspace`).
- **The Bloat**: This included the `.git` directory and the `packer_cache` (containing the 800MB+ Arch ISO).
- **The Fix**: We must update the `provisioner "file"` blocks in `packer.pkr.hcl` to be surgical. Instead of uploading the whole root, we will upload only:
    1.  `roles/`
    2.  `inventories/`
    3.  `install.yml`
    4.  `provision.yml`

## 5. Known Limitations & Technical Debt
- **Keyring Fragility**: The Arch Live ISOs sometimes ship with stale GPG keys. We have mitigated this with an explicit `archlinux-keyring` update in the bootstrap phase.
- **Line Endings**: Windows (CRLF) vs Linux (LF) remains a constant risk. We've implemented a global conversion, but new files created on Windows must be watched.
- **Secrets Management**: Sensitive vars are currently passed via environment lookups. Moving to Ansible Vault is recommended for production-ready bare-metal deployments.

---
*Last Updated: 2026-01-19*
*Next Action: Refine Packer file uploads to resolve storage exhaustion.*
