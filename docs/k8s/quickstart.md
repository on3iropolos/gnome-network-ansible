---
title: "Kubernetes Quickstart Guide"
summary: "Set up a local Kubernetes cluster using k3d in under 5 minutes using the Ansible playbook."
type: "tutorial"
scope: "repo"
tags:
  - "kubernetes"
  - "k3d"
  - "quickstart"
  - "ansible"
related:
  - "k8s/README.md"
  - "k8s/architecture.md"
  - "k8s/sample-app.md"
  - "../roles/kubernetes/README.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2026-03-24"
canonical_url: "docs/k8s/quickstart.md"
---

# Kubernetes Quickstart Guide

Set up a local Kubernetes cluster in under 5 minutes.

## Prerequisites

- Arch Linux (or compatible distribution)
- Internet connection
- sudo access

## Option 1: Automated (Recommended)

Run the Ansible playbook to provision the entire cluster:

```bash
# Dry-run first
ansible-playbook k8s.yml --check --diff

# Apply configuration
ansible-playbook k8s.yml
```

The playbook will:
1. Install Docker (if not present)
2. Install k3d binary
3. Install kubectl, helm, kubectx
4. Create the `dev-cluster` k3d cluster
5. Configure kubeconfig

## Option 2: Manual Setup

If you prefer manual setup, follow these steps:

### 1. Install Docker

```bash
sudo pacman -S docker
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
newgrp docker
```

### 2. Install k3d

```bash
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.7.0 bash
```

Or via pacman:

```bash
sudo pacman -S k3d
```

### 3. Install Kubernetes Tools

```bash
sudo pacman -S kubectl helm kubectx
```

### 4. Create Cluster

```bash
k3d cluster create dev-cluster \
  --servers 1 \
  --agents 0 \
  --port "80:80@loadbalancer" \
  --port "443:443@loadbalancer" \
  --kubeconfig-update-default
```

### 5. Verify Installation

```bash
kubectl get nodes
helm version
k3d cluster list
```

Expected output:

```
NAME                  STATUS   ROLES                  AGE   VERSION
k3d-dev-cluster      Ready    control-plane,master   1m    v1.28.x
```

## Post-Setup Verification

### Check Cluster Status

```bash
kubectl cluster-info
kubectl get pods -A
```

### Verify Add-ons

```bash
# Check Traefik ingress controller
kubectl get pods -n kube-system -l app=traefik

# Check CoreDNS
kubectl get pods -n kube-system -l k8s-app=kube-dns
```

### Test Connectivity

```bash
kubectl run curl --image=curlimages/curl --rm -it -- curl http://kubernetes.default.svc.cluster.local
```

## Configuration Options

Customize the cluster by editing `roles/kubernetes/defaults/main.yml`:

```yaml
k3d_cluster_name: "my-cluster"      # Custom cluster name
k3d_server_nodes: 1                # Control plane nodes
k3d_worker_nodes: 2                # Worker nodes
k3d_port_mapping:
  - "8080:80"                      # Custom HTTP port
  - "8443:443"                     # Custom HTTPS port
```

## Managing the Cluster

| Command | Description |
|---------|-------------|
| `k3d cluster start dev-cluster` | Start the cluster |
| `k3d cluster stop dev-cluster` | Stop the cluster |
| `k3d cluster delete dev-cluster` | Delete the cluster |
| `k3d cluster list` | List all clusters |
| `k3d kubeconfig merge dev-cluster` | Update kubeconfig |

## Troubleshooting

### Docker daemon not running

```bash
sudo systemctl start docker
```

### Cluster creation fails

```bash
# Check Docker status
docker info

# Check available resources
docker system df
```

### kubectl cannot connect

```bash
# Regenerate kubeconfig
k3d kubeconfig merge dev-cluster -o ~/.kube/config

# Verify context
kubectl config current-context
```

## Next Steps

- [Deploy a Sample Application](sample-app.md)
- [Explore Operational Playbooks](operations.md)

## Related Documentation

- [Architecture Overview](architecture.md) - Cluster components
- [Roles: kubernetes](../roles/kubernetes/README.md) - Ansible role details
