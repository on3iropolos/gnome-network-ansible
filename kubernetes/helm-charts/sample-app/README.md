# Sample Application Helm Chart

A Helm chart for deploying nginx to Kubernetes.

## Installation

```bash
# Install the chart (from the chart directory)
helm install sample-app .

# Install with custom values
helm install sample-app . \
  --set replicaCount=3 \
  --set ingress.host=myapp.local
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `replicaCount` | int | `2` | Number of replicas |
| `image.repository` | string | `nginx` | Image repository |
| `image.tag` | string | `1.25-alpine` | Image tag |
| `service.type` | string | `ClusterIP` | Service type |
| `service.port` | int | `80` | Service port |
| `ingress.enabled` | bool | `true` | Enable ingress |
| `ingress.host` | string | `nginx.local` | Ingress host |
| `resources.limits.memory` | string | `128Mi` | Memory limit |

## Testing

```bash
# Dry-run
helm template sample-app .

# Install and test
helm install sample-app .
helm test sample-app

# Uninstall
helm uninstall sample-app
```

## Upgrading

```bash
# Upgrade with new values
helm upgrade sample-app . --set replicaCount=4

# Rollback if needed
helm rollback sample-app
```

## Related Documentation

- [Getting Started](../../docs/kubernetes/getting-started.md)
