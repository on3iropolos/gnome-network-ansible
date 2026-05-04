---
title: "Kubernetes Getting Started"
summary: "Set up a local k3d cluster with Hindsight."
type: "tutorial"
scope: "repo"
tags: ["kubernetes", "k3d", "quickstart"]
last_reviewed: "2026-05-01"
canonical_url: "docs/kubernetes/getting-started.md"
---

# Kubernetes Getting Started

Set up a local k3d cluster and deploy the Hindsight memory service.

## Prerequisites

- Arch Linux with Docker installed and running
- Ansible and sudo access
- `.env` file at project root with `HINDSIGHT_API_LLM_API_KEY`

## Setup

```bash
ansible-playbook provision.yml
```

Installs Docker, k3d, kubectl, helm, creates the `dev-cluster`, and deploys Hindsight.

Verify:

```bash
kubectl get nodes
kubectl get pods -n hindsight
```

## Access

- **API**: `http://localhost:8888`
- **Control Plane UI**: `http://localhost:9999`

## Common Operations

| Task | Command |
|------|---------|
| View pods | `kubectl get pods -n hindsight` |
| View logs | `kubectl logs -f deployment/hindsight -n hindsight` |
| Scale down | `kubectl scale deployment/hindsight --replicas=0 -n hindsight` |
| Stop cluster | `k3d cluster stop dev-cluster` |
| Start cluster | `k3d cluster start dev-cluster` |
| Delete cluster | `k3d cluster delete dev-cluster` |

## Troubleshooting

```bash
kubectl describe pod <name> -n hindsight
kubectl logs <name> -n hindsight
k3d kubeconfig get dev-cluster > ~/.kube/config
```
