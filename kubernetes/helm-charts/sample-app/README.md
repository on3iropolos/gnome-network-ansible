# Sample Application Helm Chart

A Helm chart for deploying nginx to Kubernetes.

## Installation

```bash
# Install the chart
helm install nginx ./Chart

# Install with custom values
helm install nginx ./Chart --namespace default \
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
helm template nginx ./Chart

# Install and test
helm install nginx ./Chart --namespace default
helm test nginx

# Uninstall
helm uninstall nginx
```

## Upgrading

```bash
# Upgrade with new values
helm upgrade nginx ./Chart --set replicaCount=4

# Rollback if needed
helm rollback nginx
```

## Related Documentation

- [Sample Application Guide](../../docs/k8s/sample-app.md)
- [Helm Documentation](https://helm.sh/docs/)
