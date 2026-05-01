# Gnome Network Ansible

Automated configuration for Arch Linux workstations.

## Requirements

### Prerequisites
- [mise](https://mise.jdx.dev/) - Dev tool manager and task runner
- Docker: `pacman -S docker` (for Molecule testing)

### Quick Setup

```bash
# Install mise (if not already installed)
curl https://mise.run | sh

# Complete project setup (tools, collections, vault)
mise run setup
```

The vault password is in `.vault_password` (gitignored).

## Quick Start

```bash
# Dry-run
mise run provision check

# Apply
mise run provision
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

Tasks are managed via [mise](https://mise.jdx.dev/). Run `mise tasks` to list all available tasks.

```bash
# List all tasks
mise tasks

# Run any task
mise run <task-name>
```

## Available Tasks

| Task | Description |
|------|-------------|
| `mise run lint` | Run ansible-lint on all playbooks and roles |
| `mise run molecule <role>` | Run Molecule tests for a specific role |
| `mise run provision-playbook [check]` | Run Ansible provisioning (pass "check" for dry-run) |
| `mise run install-playbook` | Run installation playbook (fresh Arch installs) |
| `mise run setup` | Complete project setup (tools, collections, vault) |
| `mise run hindsight-start` | Start Hindsight memory service |
| `mise run hindsight-stop` | Stop Hindsight service |
| `mise run hindsight-logs` | View Hindsight logs |

