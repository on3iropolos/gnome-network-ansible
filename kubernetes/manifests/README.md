# Kubernetes Manifests

Raw Kubernetes YAML manifests for nginx deployment.

## Files

| File | Description |
|------|-------------|
| `nginx-deployment.yaml` | Deployment with 2 replicas, health checks |
| `nginx-service.yaml` | ClusterIP service |
| `nginx-ingress.yaml` | Ingress via Traefik |
| `app-configmap.yaml` | ConfigMap for custom configuration |

## Usage

```bash
kubectl apply -f .
```

## Access

```bash
echo "127.0.0.1 nginx.local" | sudo tee -a /etc/hosts
curl -H "Host: nginx.local" http://localhost
```

## Cleanup

```bash
kubectl delete -f .
```
