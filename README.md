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
mise run provision-playbook --check

# Apply
mise run provision-playbook
```

## Playbooks

| Playbook | Purpose |
|----------|---------|
| `provision.yml` | Configure existing Arch Linux workstation |
| `provision-vm.yml` | Provision a test VM (targets `test_vms` group) |
| `install.yml` | Fresh installation from Arch Live ISO |

## Kubernetes & Hindsight

Running `provision.yml` sets up a local k3d cluster and deploys the Hindsight memory service.

- **[Getting Started](docs/kubernetes/getting-started.md)** - Setup and usage
- **[Reference](docs/kubernetes/reference.md)** - Architecture and commands

### Access Hindsight

| Service | URL |
|---------|-----|
| API | `http://localhost:8888` |
| Control Plane | `http://localhost:9999` |

### Mise Tasks

```bash
mise run hindsight-start    # Scale Hindsight to 1 replica
mise run hindsight-stop     # Scale Hindsight to 0 replicas
mise run hindsight-logs     # Tail Hindsight logs
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
| `mise run molecule <role>` | Run Molecule tests for a specific role |
| `mise run provision-playbook [--check]` | Provision workstations |
| `mise run provision-vm-playbook [--check]` | Provision test VMs |
| `mise run install-playbook` | Fresh Arch installation from Live ISO |
| `mise run vault-edit` | Edit the encrypted vault file |
| `mise run project-setup` | Complete project setup (tools, collections, vault) |
| `mise run hindsight-start` | Start Hindsight memory service |
| `mise run hindsight-stop` | Stop Hindsight service |
| `mise run hindsight-logs` | View Hindsight logs |
