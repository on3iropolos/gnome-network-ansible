# Kubernetes Operational Playbooks

Ansible playbooks for managing Kubernetes resources.

## Prerequisites

### Python Dependencies

The Ansible `kubernetes.core` collection requires Python packages:

```bash
# On Arch Linux (requires pip)
pip install kubernetes kubernetes-validate --break-system-packages

# Or using a virtual environment (recommended)
python -m venv ~/.venv/k8s
source ~/.venv/k8s/bin/activate
pip install kubernetes kubernetes-validate

# Then run ansible with the venv activated
ansible-playbook deploy-app.yml -e manifest_file=../manifests/nginx-deployment.yaml
```

For Arch Linux, you may also need to install pip first:

```bash
sudo pacman -S python-pip
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
| `target_namespace` | Target namespace | `default` |

#### Examples

```bash
# Deploy nginx
ansible-playbook deploy-app.yml \
  -e manifest_file=../manifests/nginx-deployment.yaml

# Deploy to production namespace
ansible-playbook deploy-app.yml \
  -e manifest_file=../manifests/nginx-deployment.yaml \
  -e target_namespace=production

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
| `target_namespace` | Target namespace | `default` |

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

- [Getting Started](../../docs/kubernetes/getting-started.md)
