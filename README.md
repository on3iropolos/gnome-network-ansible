# Gnome Network Ansible

Automated configuration for Arch Linux workstations.

## Quick Start

```bash
# Copy vault template and edit
cp inventories/workstations/group_vars/workstations/vault.yml.example \
   inventories/workstations/group_vars/workstations/vault.yml
ansible-vault edit inventories/workstations/group_vars/workstations/vault.yml

# Dry-run (audit what would change)
ansible-playbook provision.yml --check --diff

# Apply changes
ansible-playbook provision.yml
```

## Requirements

- Ansible
- Access to target machine (local or SSH)

## Secrets Management

Secrets are stored in an Ansible Vault encrypted file. Copy the example template and fill in your values:

```bash
cp inventories/workstations/group_vars/workstations/vault.yml.example \
   inventories/workstations/group_vars/workstations/vault.yml
ansible-vault edit inventories/workstations/group_vars/workstations/vault.yml
```

The vault password is configured in `.vault_password` (gitignored).

## Available Playbooks

| Playbook | Purpose |
|----------|---------|
| `provision.yml` | Configure existing Arch Linux system |
| `install.yml` | Fresh installation from Arch Live ISO |

## Development

```bash
pip install -r requirements.txt
make setup
make lint
```
