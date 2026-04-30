# Gnome Network Ansible

Automated configuration for Arch Linux workstations.

## Requirements

- Ansible: `pacman -S ansible`
- [xc](https://xc.sh/) - Task runner (install via AUR: `paru -S xc-bin`)
- Python packages: `pip install -r requirements.txt`
- Ansible collections: `ansible-galaxy collection install -r requirements.yml`

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

- **[Getting Started](docs/kubernetes/getting-started.md)** - Setup and deploy
- **[kubernetes/](kubernetes/)** - Manifests, Helm charts, and playbooks

### What's Included

| Component | Description |
|-----------|-------------|
| `kubernetes/manifests/` | nginx Deployment, Service, Ingress, ConfigMap |
| `kubernetes/helm-charts/` | Production-ready Helm chart |
| `kubernetes/playbooks/` | Ansible playbooks for deployment operations |
| `docs/kubernetes/` | Getting Started and Reference guides |

## Development

Tasks are managed via [xc](https://xc.sh/) task runner. Run `xc` without arguments for the interactive task picker.

```bash
# Run linter
xc lint

# Test a role with Molecule (local)
cd roles/<role> && molecule test

# Or use xc for Molecule
xc molecule-test <role-name>
```

Open `xc` without arguments for interactive task picker.

## Tasks

### lint

Run ansible-lint on all playbooks and roles.

```bash
ansible-lint install.yml provision.yml roles/
```

### molecule-test

Run Molecule tests for a specific role (requires molecule installed).
Usage: `xc molecule-test <role-name>`
Example: `xc molecule-test <role>`

```bash
cd roles/$1 && molecule test
```

### provision

Run Ansible provisioning playbook.
Usage: `xc provision [check]` - pass "check" as argument for dry-run

```bash
ansible-galaxy collection install -r requirements.yml && ansible-playbook provision.yml ${1:+--$1}
```

### install

Run Ansible installation playbook (for fresh Arch installs).

```bash
ansible-playbook install.yml
```

### hindsight-start

Start Hindsight memory service via Docker Compose.

```bash
docker compose up -d hindsight
```

### hindsight-stop

Stop Hindsight service.

```bash
docker compose stop hindsight
```

### hindsight-logs

View Hindsight logs.

```bash
docker compose logs -f hindsight
```

