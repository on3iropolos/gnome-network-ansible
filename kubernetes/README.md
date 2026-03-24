# Kubernetes Portfolio

This directory contains Kubernetes-related content for demonstrating k8s operations experience.

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

1. [Setup k3d cluster](../../docs/k8s/quickstart.md)
2. [Deploy sample application](../../docs/k8s/sample-app.md)
3. [Explore operations](../../docs/k8s/operations.md)

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

Full documentation is available in `docs/k8s/`:
- [README](docs/k8s/README.md) - Overview
- [Architecture](docs/k8s/architecture.md) - Cluster architecture
- [Quickstart](docs/k8s/quickstart.md) - Setup guide
- [Sample App](docs/k8s/sample-app.md) - Deployment walkthrough
- [Operations](docs/k8s/operations.md) - Common operations
