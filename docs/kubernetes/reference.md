---
title: "Kubernetes Reference"
summary: "Kubernetes architecture, components, and reference commands."
type: "reference"
scope: "repo"
tags:
  - "kubernetes"
  - "k3d"
  - "reference"
related:
  - "getting-started.md"
  - "kubernetes/README.md"
  - "../roles/kubernetes/README.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2026-04-27"
canonical_url: "docs/kubernetes/reference.md"
---

# Kubernetes Reference

## Architecture

```
Host System
    │
    ▼
┌─────────────────────────────────────┐
│      k3d Cluster (Docker)           │
│  ┌───────────────────────────────┐  │
│  │  Control Plane (Server Node) │  │
│  │  - API Server               │  │
│  │  - etcd                     │  │
│  │  - Controller Manager       │  │
│  │  - Scheduler               │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │  Worker (K3s Agent)         │  │
│  │  - kubelet                  │  │
│  │  - kube-proxy              │  │
│  │  - Pods                    │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │  Add-ons                     │  │
│  │  - Traefik (Ingress)        │  │
│  │  - CoreDNS                 │  │
│  │  - metrics-server          │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

## Cluster Components

| Component | Purpose |
|-----------|---------|
| k3d | Kubernetes in Docker - creates clusters using Docker containers |
| kubectl | CLI for interacting with the cluster |
| helm | Package manager for Kubernetes manifests |
| kubectx | Switch between cluster contexts |
| Traefik | Ingress controller for HTTP routing |
| CoreDNS | Cluster DNS for service discovery |

## Directory Structure

```
kubernetes/
├── manifests/         # Raw YAML manifests
│   ├── nginx-deployment.yaml
│   ├── nginx-service.yaml
│   ├── nginx-ingress.yaml
│   └── app-configmap.yaml
├── helm-charts/        # Helm charts
│   └── sample-app/
├── playbooks/         # Ansible operations
│   ├── deploy-app.yml
│   └── scale.yml
└── README.md
```

## Key Commands

### Cluster Management

```bash
k3d cluster create dev-cluster --servers 1 --agents 0 --port "80:80"
k3d cluster list
k3d cluster start dev-cluster
k3d cluster stop dev-cluster
k3d cluster delete dev-cluster
```

### kubectl Basics

```bash
kubectl get nodes                    # List nodes
kubectl get pods -A                  # List all pods
kubectl get svc -A                   # List services
kubectl get ingress -A                # List ingresses
kubectl get all -n <namespace>      # List all resources in namespace
kubectl apply -f <file.yaml>        # Apply manifest
kubectl delete -f <file.yaml>       # Delete manifest
kubectl describe <resource> <name>   # Get resource details
kubectl logs <pod> -n <namespace>    # Get pod logs
kubectl exec -it <pod> -n <namespace> -- /bin/sh  # Shell into pod
```

### Helm

```bash
helm list -A                        # List releases
helm install <name> <chart>         # Install chart
helm upgrade <name> <chart>        # Upgrade release
helm uninstall <name> -n <namespace>  # Uninstall
helm get all <name> -n <namespace>  # Get release details
```

### Debugging

```bash
kubectl logs <pod> -n <namespace>
kubectl describe <type> <name> -n <namespace>
kubectl get events -A --sort-by='.lastTimestamp'
kubectl top nodes
kubectl top pods -n <namespace>
```