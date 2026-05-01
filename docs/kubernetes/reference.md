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
  - "../roles/kubernetes/README.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2026-05-01"
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
│  │    - Hindsight Deployment  │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │  Add-ons                     │  │
│  │  - Traefik (Ingress)        │  │
│  │  - CoreDNS                 │  │
│  │  - metrics-server          │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
        │                    │
        ▼                    ▼
    :8888 (API)         :9999 (Control)
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

## Hindsight Workload

| Resource | Type | Purpose |
|----------|------|---------|
| `hindsight` namespace | Namespace | Isolates Hindsight resources |
| `hindsight-env` | Secret | Stores environment variables from `.env` |
| `hindsight-data` | PVC | Persistent storage for Hindsight data |
| `hindsight` | Deployment | Runs the Hindsight container |
| `hindsight` | Service (LoadBalancer) | Exposes API (8888) and Control Plane (9999) |

## Directory Structure

```
roles/kubernetes/
├── meta/main.yml              # Role metadata and dependencies
├── tasks/
│   ├── main.yml               # Entry point
│   ├── install_k3d.yml        # Install k3d binary
│   ├── install_tools.yml      # Install kubectl, helm, kubectx
│   ├── create_cluster.yml     # Create k3d cluster
│   ├── deploy_hindsight.yml   # Deploy Hindsight workload
│   └── verify.yml             # Verify installation
├── templates/
│   ├── hindsight-namespace.yaml.j2
│   ├── hindsight-deployment.yaml.j2
│   ├── hindsight-service.yaml.j2
│   └── hindsight-pvc.yaml.j2
├── defaults/main.yml          # Role variables
├── README.md
└── molecule/                  # Integration tests
```

## Key Commands

### Cluster Management

```bash
k3d cluster create dev-cluster --servers 1 --agents 0 --port "80:80" --port "8888:8888@loadbalancer"
k3d cluster list
k3d cluster start dev-cluster
k3d cluster stop dev-cluster
k3d cluster delete dev-cluster
```

### kubectl Basics

```bash
kubectl get nodes                    # List nodes
kubectl get pods -A                  # List all pods
kubectl get pods -n hindsight        # List Hindsight pods
kubectl get svc -n hindsight         # List Hindsight services
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
