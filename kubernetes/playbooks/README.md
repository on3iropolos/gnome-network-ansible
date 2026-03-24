# Kubernetes Operational Playbooks

Ansible playbooks for managing Kubernetes resources.

## Prerequisites

```bash
pip install kubernetes
```

## Playbooks

### deploy-app.yml

Deploy a Kubernetes application from a manifest file.

```bash
ansible-playbook deploy-app.yml \
  -e manifest_file=../manifests/nginx-deployment.yaml
```

#### Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `manifest_file` | Path to Kubernetes YAML manifest | Required |
| `state` | Resource state | `present` |
| `namespace` | Target namespace | `default` |

#### Examples

```bash
# Deploy nginx
ansible-playbook deploy-app.yml \
  -e manifest_file=../manifests/nginx-deployment.yaml

# Deploy to production namespace
ansible-playbook deploy-app.yml \
  -e manifest_file=../manifests/nginx-deployment.yaml \
  -e namespace=production

# Delete resources
ansible-playbook deploy-app.yml \
  -e manifest_file=../manifests/nginx-deployment.yaml \
  -e state=absent
```

### scale.yml

Scale a Kubernetes deployment.

```bash
ansible-playbook scale.yml \
  -e app_name=nginx \
  -e replicas=4
```

#### Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `app_name` | Deployment name | Required |
| `replicas` | Number of replicas | `1` |
| `namespace` | Target namespace | `default` |

#### Examples

```bash
# Scale to 4 replicas
ansible-playbook scale.yml \
  -e app_name=nginx \
  -e replicas=4

# Scale to 0 (scale to zero pattern)
ansible-playbook scale.yml \
  -e app_name=nginx \
  -e replicas=0
```

## Related Documentation

- [Operations Guide](../../docs/k8s/operations.md)
- [Sample Application Tutorial](../../docs/k8s/sample-app.md)
