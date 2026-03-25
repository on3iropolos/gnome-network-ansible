# Kubernetes Portfolio

This directory contains Kubernetes-related content for demonstrating Kubernetes operations experience.

## Structure

```
kubernetes/
├── manifests/           # Kubernetes YAML manifests
│   ├── nginx-deployment.yaml
│   ├── nginx-service.yaml
│   ├── nginx-ingress.yaml
│   ├── app-configmap.yaml
│   └── README.md
├── helm-charts/        # Helm charts
│   └── sample-app/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── templates/
│       └── README.md
├── playbooks/          # Ansible operational playbooks
│   ├── deploy-app.yml
│   ├── scale.yml
│   └── README.md
└── README.md           # This file
```

## Quick Start

1. [Setup k3d cluster](../../docs/kubernetes/quickstart.md)
2. [Deploy sample application](../../docs/kubernetes/sample-app.md)
3. [Explore operations](../../docs/kubernetes/operations.md)

## Contents

### Manifests

Raw Kubernetes YAML manifests for nginx deployment:
- Deployment with 2 replicas, health checks, resource limits
- ClusterIP service
- Ingress with Traefik
- ConfigMap for configuration

### Helm Charts

Production-ready Helm chart with:
- Configurable replicas, image, resources
- Health checks (liveness/readiness probes)
- Ingress support
- Helm tests

### Playbooks

Ansible playbooks for:
- Deploying applications from manifests
- Scaling deployments

## Documentation

Full documentation is available in `docs/kubernetes/`:
- [README](docs/kubernetes/README.md) - Overview
- [Architecture](docs/kubernetes/architecture.md) - Cluster architecture
- [Quickstart](docs/kubernetes/quickstart.md) - Setup guide
- [Sample App](docs/kubernetes/sample-app.md) - Deployment walkthrough
- [Operations](docs/kubernetes/operations.md) - Common operations
