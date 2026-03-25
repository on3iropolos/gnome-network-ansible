---
title: "Sample nginx Application Deployment"
summary: "Step-by-step walkthrough for deploying an nginx web server to the k3d cluster using both raw manifests and Helm charts."
type: "tutorial"
scope: "repo"
tags:
  - "kubernetes"
  - "nginx"
  - "deployment"
  - "helm"
  - "ingress"
related:
  - "kubernetes/README.md"
  - "kubernetes/architecture.md"
  - "kubernetes/quickstart.md"
  - "kubernetes/operations.md"
  - "../../kubernetes/manifests"
  - "../../kubernetes/helm-charts"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2026-03-24"
canonical_url: "docs/kubernetes/sample-app.md"
---

# Sample nginx Application Deployment

Deploy an nginx web server to demonstrate Kubernetes deployment patterns.

## Method 1: Raw Kubernetes Manifests

### Deploy nginx

```bash
kubectl apply -f kubernetes/manifests/nginx-deployment.yaml
kubectl apply -f kubernetes/manifests/nginx-service.yaml
kubectl apply -f kubernetes/manifests/nginx-ingress.yaml
kubectl apply -f kubernetes/manifests/app-configmap.yaml
```

### Verify Deployment

```bash
# Check deployment status
kubectl get deployments
kubectl get pods
kubectl get services
kubectl get ingress

# Describe deployment for details
kubectl describe deployment nginx
```

### Access the Application

```bash
# Via service (internal)
kubectl run curl --image=curlimages/curl --rm -it -- curl http://nginx.default.svc.cluster.local

# Via ingress (external)
curl -H "Host: nginx.local" http://localhost
```

### Expected Output

```
NAME                         READY   UP-TO-DATE   AVAILABLE
deployment.apps/nginx        2/2     2            2

NAME              TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)
service/nginx     ClusterIP   10.43.56.789   <none>        80/TCP

NAME              CLASS   HOSTS       ADDRESS        PORTS
ingress.networking.k8s.io/nginx   traefik   nginx.local   172.19.0.2   80
```

## Method 2: Helm Chart

### Install the Chart

```bash
cd kubernetes/helm-charts/sample-app
helm install sample-app .

# Or with custom values
helm install sample-app . \
  --set replicaCount=3 \
  --set image.tag=alpine
```

### Verify Helm Release

```bash
helm list
helm status sample-app
kubectl get pods -l app.kubernetes.io/name=sample-app
```

### Upgrade the Release

```bash
helm upgrade sample-app . \
  --set replicaCount=4 \
  --set image.tag=1.25
```

### Rollback if Needed

```bash
helm rollback sample-app
```

## Manifest Files Explained

### Deployment

The nginx Deployment creates 2 replicas with:

- Rolling update strategy
- Health checks (liveness/readiness probes)
- Resource limits
- ConfigMap mounting

Key fields:

```yaml
spec:
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    spec:
      containers:
        - name: nginx
          image: nginx:1.25
          ports:
            - containerPort: 80
          livenessProbe:
            httpGet:
              path: /
              port: 80
          resources:
            limits:
              memory: "128Mi"
              cpu: "500m"
```

### Service

The ClusterIP service exposes nginx internally:

```yaml
spec:
  type: ClusterIP
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
```

### Ingress

The ingress routes external traffic via Traefik:

```yaml
spec:
  ingressClassName: traefik
  rules:
    - host: nginx.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nginx
                port:
                  number: 80
```

### ConfigMap

Configuration injected as environment variables:

```yaml
data:
  NGINX_PORT: "80"
  LOG_LEVEL: "info"
```

## Scaling the Application

### Scale with kubectl

```bash
kubectl scale deployment nginx --replicas=4
```

### Scale with Ansible

```bash
ansible-playbook kubernetes/playbooks/scale.yml \
  -e app_name=sample-app \
  -e replicas=4
```

## Cleaning Up

```bash
# Remove resources
kubectl delete -f kubernetes/manifests/

# Or via Helm
helm uninstall sample-app

# Delete cluster
k3d cluster delete dev-cluster
```

## Next Steps

- [Explore Operational Playbooks](operations.md)
- [Understand Cluster Architecture](architecture.md)

## Related Files

- [nginx Deployment Manifest](../kubernetes/manifests/nginx-deployment.yaml)
- [nginx Service Manifest](../kubernetes/manifests/nginx-service.yaml)
- [nginx Ingress Manifest](../kubernetes/manifests/nginx-ingress.yaml)
- [Sample Helm Chart](../kubernetes/helm-charts/sample-app)
