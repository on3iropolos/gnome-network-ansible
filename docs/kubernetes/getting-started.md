---
title: "Kubernetes Getting Started"
summary: "Set up a local k3d cluster and deploy your first application."
type: "tutorial"
scope: "repo"
tags:
  - "kubernetes"
  - "k3d"
  - "quickstart"
related:
  - "kubernetes/README.md"
  - "../roles/kubernetes/README.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2026-04-27"
canonical_url: "docs/kubernetes/getting-started.md"
---

# Kubernetes Getting Started

Set up a local Kubernetes cluster and deploy a sample application.

## Prerequisites

- Arch Linux (or compatible distribution)
- Docker installed and running
- Ansible installed
- Internet connection
- sudo access

## Setup Cluster

Run the Ansible playbook:

```bash
ansible-playbook k8s.yml
```

This installs: Docker, k3d, kubectl, helm, kubectx, and creates the `dev-cluster`.

### Verify

```bash
kubectl get nodes
kubectl get pods -A
```

## Deploy Sample App

### Option 1: Helm Chart (Recommended)

```bash
helm install sample-app kubernetes/helm-charts/sample-app \
  --namespace dev --create-namespace
```

### Option 2: Raw Manifests

```bash
kubectl apply -f kubernetes/manifests/
kubectl apply -f docs/kubernetes-ingress.yaml
```

## Access the Application

Add to `/etc/hosts`:
```
127.0.0.1 nginx.local
```

Then access: `http://nginx.local`

## Common Operations

| Task | Command |
|------|---------|
| Scale app | `kubectl scale deployment sample-app --replicas=5 -n dev` |
| View pods | `kubectl get pods -n dev` |
| View logs | `kubectl logs -n dev -l app.kubernetes.io/instance=sample-app` |
| Delete app | `helm uninstall sample-app -n dev` |
| Stop cluster | `k3d cluster stop dev-cluster` |
| Start cluster | `k3d cluster start dev-cluster` |
| Delete cluster | `k3d cluster delete dev-cluster` |

## Troubleshooting

### Pods not starting
```bash
kubectl describe pod <pod-name> -n dev
kubectl logs <pod-name> -n dev
```

### Can't connect to cluster
```bash
k3d kubeconfig get dev-cluster > ~/.kube/config
kubectl config use-context k3d-dev-cluster
```

### Traefik not routing
```bash
kubectl rollout restart deployment -n kube-system traefik
```