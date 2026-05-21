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
mise run project-setup
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
| `deploy.yml` | Configure virtual hosts |

## Kubernetes & Hindsight

Running `provision.yml` sets up a local k3d cluster and deploys the Hindsight memory service.

- **[Getting Started](docs/kubernetes/getting-started.md)** - Setup and usage
- **[Reference](docs/kubernetes/reference.md)** - Architecture and commands

### Access Hindsight

| Service | URL |
|---------|-----|
| API | `http://localhost:8888` |
| Control Plane | `http://localhost:9999` |

### Hindsight Tasks

```bash
mise run hindsight-start    # Scale Hindsight to 1 replica
mise run hindsight-stop     # Scale Hindsight to 0 replicas
mise run hindsight-logs     # Tail Hindsight logs
mise run hindsight-status   # Check Hindsight deployment status
```

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
| `mise run yamllint` | Lint all YAML files in the project |
| `mise run check` | Run all pre-commit checks (yamllint + ansible-lint) |
| `mise run molecule <role>` | Run Molecule tests for a specific role |
| `mise run molecule-all` | Run Molecule tests for all roles with tests |
| `mise run provision-playbook [--check]` | Run Ansible provisioning (add --check for dry-run) |
| `mise run install-playbook` | Run installation playbook (fresh Arch installs) |
| `mise run deploy-playbook [--check]` | Run deploy playbook for virtual hosts |
| `mise run project-setup` | Complete project setup (tools, collections, vault) |
| `mise run galaxy-install` | Install Ansible Galaxy collections |
| `mise run vault-edit` | Edit Ansible vault encrypted file |
| `mise run vault-view` | View Ansible vault encrypted file |
| `mise run list-roles` | List all Ansible roles |
| `mise run hindsight-start` | Start Hindsight memory service |
| `mise run hindsight-stop` | Stop Hindsight service |
| `mise run hindsight-logs` | View Hindsight logs |
| `mise run hindsight-status` | Check Hindsight deployment status |
