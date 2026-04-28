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

```bash
make setup      # Install deps and pre-commit hooks
make lint      # Run ansible-lint
cd roles/<role> && molecule test  # Test a role
```

## Issue Tracking with Beads (bd)

This project uses **Beads** (`bd`) for all issue tracking and task management.

### Installation

```bash
# Install Beads CLI
curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash

# Add to PATH (add to ~/.bashrc)
export PATH="$PATH:$HOME/.local/bin"
```

### Stealth Mode Setup

This repository uses **stealth mode** - Beads database is local-only and not committed to git.

```bash
# Initialize in stealth mode (already done)
bd init --stealth

# Verify setup
bd info --json
```

**Note:** In stealth mode, `.beads/` is added to `.git/info/exclude` (local-only). No git hooks are installed. You must manually run `bd sync` at session end.

### Essential Commands

```bash
# Find unblocked work
bd ready --json

# Create new issue
bd create "Issue title" --description="Details" -t task|bug|feature -p 0-4 --json

# Claim and work on issue
bd update <id> --claim --json

# Complete work
bd close <id> --reason "Completed" --json

# Check project status
bd list --status open --json
bd stats
```

### OpenCode Integration

The `opencode-beads` plugin is installed for automatic context injection:

- Runs `bd prime` on session start (lazily, on first prompt)
- Provides `/bd-*` slash commands
- Preserves context through session compaction

### Key Rules

- ✅ Use `bd` for ALL task tracking (no markdown TODOs)
- ✅ Always use `--json` flag for programmatic access
- ✅ Run `bd sync` at session end
- ❌ Do NOT create markdown TODO lists
- ❌ Do NOT use external issue trackers

For full documentation: https://gastownhall.github.io/beads/

Full documentation: see `docs/` directory.
