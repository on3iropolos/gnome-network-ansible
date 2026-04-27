# Kubernetes Portfolio

Content for demonstrating Kubernetes operations experience.

## Structure

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
└── README.md           # This file
```

## Contents

| Directory | Description |
|-----------|-------------|
| `manifests/` | Raw K8s YAML (Deployment, Service, Ingress, ConfigMap) |
| `helm-charts/sample-app/` | Production-ready Helm chart |
| `playbooks/` | Ansible deployment & scaling playbooks |

## Quick Start

1. Setup cluster: `ansible-playbook k8s.yml`
2. Deploy app: `helm install sample-app kubernetes/helm-charts/sample-app --namespace dev --create-namespace`
3. Access: Add `127.0.0.1 nginx.local` to `/etc/hosts`, then visit `http://nginx.local`

## Reference

- [Getting Started](docs/kubernetes/getting-started.md)
- [Reference](docs/kubernetes/reference.md)
