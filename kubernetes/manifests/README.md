# Kubernetes Manifests

This directory contains Kubernetes YAML manifests for the sample nginx application.

## Files

| File | Description |
|------|-------------|
| `nginx-deployment.yaml` | Deployment with 2 replicas, health checks, and resource limits |
| `nginx-service.yaml` | ClusterIP service exposing the nginx deployment |
| `nginx-ingress.yaml` | Ingress resource for external access via Traefik |
| `app-configmap.yaml` | ConfigMap with environment variables and custom HTML |

## Usage

Apply all manifests:

```bash
kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service.yaml
kubectl apply -f nginx-ingress.yaml
kubectl apply -f app-configmap.yaml
```

Or apply all at once:

```bash
kubectl apply -f .
```

## Testing

Access the application:

```bash
# Add hosts entry
echo "127.0.0.1 nginx.local" | sudo tee -a /etc/hosts

# Test access
curl -H "Host: nginx.local" http://localhost
```

## Cleanup

```bash
kubectl delete -f .
```
