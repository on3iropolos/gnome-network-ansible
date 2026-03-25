---
title: "Kubernetes Portfolio Showcase"
summary: "Dedicated Kubernetes operations documentation for demonstrating Kubernetes experience in job interviews and portfolio presentations."
type: "reference"
scope: "repo"
tags:
  - "kubernetes"
  - "k3d"
  - "portfolio"
  - "ansible"
related:
  - "k8s/architecture.md"
  - "k8s/quickstart.md"
  - "k8s/sample-app.md"
  - "k8s/operations.md"
  - "../roles/kubernetes/README.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2026-03-24"
canonical_url: "docs/k8s/README.md"
---

# Kubernetes Portfolio Showcase

This section contains Kubernetes operations documentation for demonstrating Kubernetes experience in job interviews and technical presentations.

## Quick Links

| Topic | Description |
|-------|-------------|
| [Architecture](architecture.md) | k3d cluster architecture and components |
| [Quickstart](quickstart.md) | 5-minute cluster setup guide |
| [Sample Application](sample-app.md) | nginx deployment walkthrough |
| [Operations](operations.md) | Deploy and scale playbooks |

## What's Included

### Cluster Provisioning
- **k3d** - Lightweight Kubernetes cluster running in Docker
- **kubectl** - Kubernetes CLI for cluster interaction
- **Helm** - Package manager for Kubernetes
- **kubectx** - Context/namespaceswitcher

### Sample Deployments
- nginx web server deployment
- ClusterIP service
- Ingress resource with Traefik
- ConfigMap for configuration

### Operational Tools
- Ansible playbooks for deployment automation
- Helm chart for application packaging
- Molecule tests for role validation

## Directory Structure

```
kubernetes/
├── manifests/           # Kubernetes YAML manifests
│   ├── nginx-deployment.yaml
│   ├── nginx-service.yaml
│   ├── nginx-ingress.yaml
│   └── app-configmap.yaml
├── helm-charts/        # Helm charts
│   └── sample-app/
├── playbooks/          # Ansible operational playbooks
│   ├── deploy-app.yml
│   └── scale.yml
└── README.md

docs/kubernetes/              # This documentation
```

## Getting Started

1. [Setup your k3d cluster](quickstart.md)
2. [Deploy the sample application](sample-app.md)
3. [Explore operations](operations.md)

## Prerequisites

- Arch Linux (or compatible distribution)
- Docker installed and running
- Ansible installed
- Internet connectivity for downloading k3d and images
