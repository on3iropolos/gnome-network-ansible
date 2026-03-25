---
title: "Kubernetes Operations Guide"
summary: "Common Kubernetes operational tasks including deploying applications, scaling workloads, and managing the cluster using Ansible playbooks."
type: "how-to"
scope: "repo"
tags:
  - "kubernetes"
  - "operations"
  - "ansible"
  - "deployment"
  - "scaling"
related:
  - "kubernetes/README.md"
  - "kubernetes/quickstart.md"
  - "kubernetes/sample-app.md"
  - "../../kubernetes/playbooks"
  - "../../roles/kubernetes/README.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2026-03-24"
canonical_url: "docs/kubernetes/operations.md"
---

# Kubernetes Operations Guide

Common operational tasks for managing the k3d Kubernetes cluster.

## Ansible Playbooks

### Deploy Application

Deploy an application to the cluster using the Ansible playbook:

```bash
cd kubernetes/playbooks
ansible-playbook deploy-app.yml \
  -e manifest_file=../manifests/nginx-deployment.yaml
```

#### Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `manifest_file` | Path to Kubernetes manifest | Required |
| `namespace` | Target namespace | `default` |
| `state` | Resource state | `present` |

#### Examples

```bash
# Deploy to specific namespace
ansible-playbook deploy-app.yml \
  -e manifest_file=../manifests/nginx-deployment.yaml \
  -e namespace=production

# Delete resources instead of applying
ansible-playbook deploy-app.yml \
  -e manifest_file=../manifests/nginx-deployment.yaml \
  -e state=absent
```

### Scale Application

Scale a deployment up or down:

```bash
ansible-playbook scale.yml \
  -e app_name=nginx \
  -e replicas=4
```

#### Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `app_name` | Name of the deployment | Required |
| `replicas` | Number of replicas | `1` |
| `namespace` | Target namespace | `default` |

## Manual kubectl Commands

### Deployments

```bash
# Apply manifests
kubectl apply -f <manifest-file.yaml>
kubectl apply -k <kustomization-dir/>

# List deployments
kubectl get deployments -A

# Scale deployment
kubectl scale deployment <name> --replicas=<count>

# View rollout history
kubectl rollout history deployment/<name>

# Rollback to previous version
kubectl rollout undo deployment/<name>

# Rollback to specific revision
kubectl rollout undo deployment/<name> --to-revision=<n>
```

### Services

```bash
# Expose deployment as service
kubectl expose deployment <name> --type=LoadBalancer --port=80

# Port forward to local machine
kubectl port-forward svc/<name> 8080:80

# Forward to specific pod
kubectl port-forward pod/<name> 8080:80
```

### Debugging

```bash
# Get pod logs
kubectl logs <pod-name>
kubectl logs <pod-name> -f

# Follow logs from all pods in deployment
kubectl logs -l app=<label> -f

# Describe resource for details
kubectl describe <resource> <name>

# Execute command in pod
kubectl exec -it <pod-name> -- /bin/sh

# Check resource usage
kubectl top pods
kubectl top nodes
```

### Namespaces

```bash
# Create namespace
kubectl create namespace <name>

# Switch default namespace
kubectl config set-context --current --namespace=<name>

# List all resources in namespace
kubectl get all -n <name>
```

### Health Checks

```bash
# Check pod status
kubectl get pods --field-selector=status.phase=Running

# Watch pod status
kubectl get pods -w

# Check events
kubectl get events --sort-by='.lastTimestamp'
```

## Helm Operations

```bash
# Install chart
helm install <release> <chart>

# List releases
helm list

# Upgrade release
helm upgrade <release> <chart>

# Rollback release
helm rollback <release>

# Uninstall release
helm uninstall <release>

# Template chart locally
helm template <release> <chart>

# Dry-run install
helm install <release> <chart> --dry-run
```

## Cluster Management

### k3d Commands

```bash
# Start/stop cluster
k3d cluster start dev-cluster
k3d cluster stop dev-cluster

# Delete cluster
k3d cluster delete dev-cluster

# Get cluster info
k3d cluster get dev-cluster

# Export kubeconfig
k3d kubeconfig merge dev-cluster -o ~/.kube/config
```

### Docker Context

```bash
# Switch to k3d cluster context
kubectl config use-context k3d-dev-cluster

# List contexts
kubectl config get-contexts

# View current context
kubectl config current-context
```

## Common Workflows

### Rolling Update

```bash
# Update image version
kubectl set image deployment/<name> <container>=<image>:<tag>

# Watch rollout progress
kubectl rollout status deployment/<name>
```

### Backup and Restore

```bash
# Backup all resources
kubectl get all -A -o yaml > backup.yaml

# Restore from backup
kubectl apply -f backup.yaml
```

### Resource Cleanup

```bash
# Delete completed pods
kubectl delete pods --field-selector=status.phase!=Running

# Delete evicted pods
kubectl get pods --field-selector=status.phase=Evicted -o name | xargs -r kubectl delete

# Remove completed/failed jobs
kubectl delete jobs --field-selector=status.successful!=1
```

## Related Files

- [Deploy App Playbook](../../kubernetes/playbooks/deploy-app.yml)
- [Scale Playbook](../../kubernetes/playbooks/scale.yml)
- [Kubernetes Role](../../roles/kubernetes/README.md)
