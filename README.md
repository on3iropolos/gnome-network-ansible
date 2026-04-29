# Gnome Network Ansible

Automated configuration for Arch Linux workstations.

## Requirements

- Ansible: `pacman -S ansible` or `pip install ansible`
- [xc](https://xc.sh/) - Task runner (install via AUR: `paru -S xc-bin`)
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

Tasks are managed via [xc](https://xc.sh/) task runner. Run `xc` without arguments for the interactive task picker.

```bash
# Install pre-commit hooks
xc setup

# Run linter
xc lint

# Build development Docker image
xc docker-build

# Run interactive dev shell in Docker
xc docker-dev

# Test a role with Molecule (local)
cd roles/<role> && molecule test

# Or use xc for Molecule
xc molecule-test <role-name>
```

Open `xc` without arguments for interactive task picker.

## Tasks

### setup

Install pre-commit hooks (runs locally, requires pre-commit: `pip install pre-commit`).

```bash
pre-commit install
```

### lint

Run ansible-lint on all playbooks and roles.

```bash
docker run --rm -v "$(pwd):/data" -w /data gnome-network-ansible ansible-lint install.yml provision.yml roles/
```

### docker-build

Build the development Docker image.

```bash
docker build -t gnome-network-ansible .
```

### docker-dev

Run an interactive development shell in Docker.

```bash
docker run -it --rm -v "$(pwd):/data" -v /var/run/docker.sock:/var/run/docker.sock -v ~/.ssh:/root/.ssh:ro -w /data gnome-network-ansible
```

### molecule-test

Run Molecule tests for a specific role.
Usage: `xc molecule-test <role-name>`
Example: `xc molecule-test docker`

```bash
docker run --rm -v "$(pwd):/data" -v /var/run/docker.sock:/var/run/docker.sock -w /data gnome-network-ansible bash -c "cd roles/$1 && molecule test"
```

### provision

Run Ansible provisioning playbook.
Usage: `xc provision [check]` - pass "check" as argument for dry-run

```bash
docker run --rm --network=host \
  -v "$(pwd):/data" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.ssh:/root/.ssh:ro \
  -e USER="$(whoami)" \
  --entrypoint /bin/bash \
  gnome-network-ansible \
  -c "ansible-galaxy collection install -r requirements.yml && ansible-playbook provision.yml ${1:+--$1}"
```

### install

Run Ansible installation playbook (for fresh Arch installs).

```bash
docker run --rm -v "$(pwd):/data" -v /var/run/docker.sock:/var/run/docker.sock -v ~/.ssh:/root/.ssh:ro -w /data gnome-network-ansible ansible-playbook install.yml
```

### hindsight-start

Start Hindsight memory service via Docker.

```bash
docker run -d --name hindsight \
  -p 8888:8888 -p 9999:9999 \
  --env-file .env \
  -e HINDSIGHT_API_LLM_PROVIDER=gemini \
  -v hindsight-data:/home/hindsight/.pg0 \
  --restart unless-stopped \
  ghcr.io/vectorize-io/hindsight:latest
```

### hindsight-stop

Stop and remove Hindsight service.

```bash
docker stop hindsight && docker rm hindsight
```

### hindsight-logs

View Hindsight logs.

```bash
docker logs -f hindsight
```

### hindsight-migrate

Migrate `.agent/` memories to Hindsight.

```bash
python scripts/migrate-to-hindsight.py
```

## Issue Tracking with Beads (bd)

Full documentation: see `docs/` directory.
