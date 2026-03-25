# Gnome Network Ansible

Automated configuration for Arch Linux workstations.

## Requirements

- Ansible: `pacman -S ansible` or `pip install ansible`
- Access to target machine (local or SSH)

## Setup

```bash
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
cp inventories/group_vars/workstations/vault.yml.example \
   inventories/group_vars/workstations/vault.yml
ansible-vault edit inventories/group_vars/workstations/vault.yml
```

The vault password is in `.vault_password` (gitignored).

## Quick Start

```bash
# Dry-run
ansible-playbook provision.yml --check --diff

# Apply
ansible-playbook provision.yml
```

## Playbooks

| Playbook | Purpose |
|----------|---------|
| `provision.yml` | Configure existing Arch Linux system |
| `install.yml` | Fresh installation from Arch Live ISO |
| `k8s.yml` | Local Kubernetes cluster (k3d) |

## Kubernetes Portfolio

For Kubernetes demonstrations and portfolio showcase, see:

- **[Kubernetes Documentation](docs/kubernetes/README.md)** - Full Kubernetes documentation
- **[kubernetes/](kubernetes/)** - Manifests, Helm charts, and playbooks

### What's Included

| Component | Description |
|-----------|-------------|
| `kubernetes/manifests/` | nginx Deployment, Service, Ingress, ConfigMap |
| `kubernetes/helm-charts/` | Production-ready Helm chart |
| `kubernetes/playbooks/` | Ansible playbooks for deployment operations |
| `docs/kubernetes/` | Architecture, quickstart, sample app, operations guide |

## Development

```bash
make setup      # Install deps and pre-commit hooks
make lint      # Run ansible-lint
cd roles/<role> && molecule test  # Test a role
```

Full documentation: see `docs/` directory.
