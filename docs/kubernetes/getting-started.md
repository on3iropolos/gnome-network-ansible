---
title: "Kubernetes Getting Started"
summary: "Set up a local k3d cluster with Hindsight."
type: "tutorial"
scope: "repo"
tags:
  - "kubernetes"
  - "k3d"
  - "quickstart"
related:
  - "../roles/kubernetes/README.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2026-05-01"
canonical_url: "docs/kubernetes/getting-started.md"
---

# Kubernetes Getting Started

Set up a local Kubernetes cluster and deploy the Hindsight memory service.

## Prerequisites

- Arch Linux (or compatible distribution)
- Docker installed and running
- Ansible installed
- Internet connection
- sudo access
- `.env` file at project root with `HINDSIGHT_API_LLM_API_KEY` set

## Setup Cluster

Run the Ansible provisioning playbook:

```bash
ansible-playbook provision.yml
```

This installs: Docker, k3d, kubectl, helm, kubectx, creates the `dev-cluster`, and deploys Hindsight.

### Verify

```bash
kubectl get nodes
kubectl get pods -n hindsight
```

## Access Hindsight

Hindsight is accessible at:

- **API**: `http://localhost:8888`
- **Control Plane**: `http://localhost:9999`

## Common Operations

| Task | Command |
|------|---------|
| View pods | `kubectl get pods -n hindsight` |
| View logs | `kubectl logs -f deployment/hindsight -n hindsight` |
| Scale down | `kubectl scale deployment/hindsight --replicas=0 -n hindsight` |
| Scale up | `kubectl scale deployment/hindsight --replicas=1 -n hindsight` |
| Stop cluster | `k3d cluster stop dev-cluster` |
| Start cluster | `k3d cluster start dev-cluster` |
| Delete cluster | `k3d cluster delete dev-cluster` |

### Mise Tasks

```bash
mise run hindsight-start    # Scale deployment to 1
mise run hindsight-stop     # Scale deployment to 0
mise run hindsight-logs     # Tail Hindsight logs
```

## Troubleshooting

### Pods not starting
```bash
kubectl describe pod <pod-name> -n hindsight
kubectl logs <pod-name> -n hindsight
```

### Can't connect to cluster
```bash
k3d kubeconfig get dev-cluster > ~/.kube/config
kubectl config use-context k3d-dev-cluster
```

### Port conflicts
If ports 8888 or 9999 are in use:
```bash
k3d cluster delete dev-cluster
# Free the port, then re-run provision.yml
```

### Missing .env file
Ensure `.env` exists at the project root with `HINDSIGHT_API_LLM_API_KEY` set.
