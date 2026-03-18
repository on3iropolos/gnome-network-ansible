# Gnome Network Ansible

Automated configuration for Arch Linux workstations.

## Requirements

- Ansible (install via `pip install ansible` or `pacman -S ansible`)
- Access to target machine (local or SSH)

```bash
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
```

## Quick Start

```bash
# Copy vault template and edit
cp inventories/group_vars/workstations/vault.yml.example \
   inventories/group_vars/workstations/vault.yml
ansible-vault edit inventories/group_vars/workstations/vault.yml

# Dry-run (audit what would change)
ansible-playbook provision.yml --check --diff

# Apply changes
ansible-playbook provision.yml
```

## Secrets Management

Secrets are stored in an Ansible Vault encrypted file. Copy the example template and fill in your values:

```bash
cp inventories/group_vars/workstations/vault.yml.example \
   inventories/group_vars/workstations/vault.yml
ansible-vault edit inventories/group_vars/workstations/vault.yml
```

The vault password is configured in `.vault_password` (gitignored).

## Available Playbooks

| Playbook | Purpose |
|----------|---------|
| `provision.yml` | Configure existing Arch Linux system |
| `install.yml` | Fresh installation from Arch Live ISO |
| `k8s.yml` | Local Kubernetes development cluster (k3d) |

## Kubernetes Development Cluster

This repository includes Ansible roles to set up a local Kubernetes development cluster using [k3d](https://k3d.io/).

```bash
# Setup k3d cluster with demo app
ansible-playbook k8s.yml

# Verify cluster
kubectl get nodes
kubectl get pods -A
```

### What It Does

1. Installs Docker (if not present)
2. Installs k3d, kubectl, helm, kubectx
3. Creates a k3d cluster

### Customization

Edit `roles/kubernetes/defaults/main.yml` to customize:
- Cluster name
- Number of server/worker nodes
- Port mappings

## Development

```bash
# Install deps and setup pre-commit hooks
pip install -r requirements.txt
make setup

# Lint (ansible-lint)
make lint

# Test roles with Molecule
cd roles/<role-name> && molecule test
```

Full documentation: see `docs/` directory.
