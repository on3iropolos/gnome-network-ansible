---
title: "Kubernetes Reference"
summary: "Kubernetes architecture, components, and reference commands."
type: "reference"
scope: "repo"
tags: ["kubernetes", "k3d", "reference"]
last_reviewed: "2026-05-01"
canonical_url: "docs/kubernetes/reference.md"
---

# Kubernetes Reference

## Architecture

```
Host
 │
 ├─ k3d serverlb (nginx proxy)    → localhost:80,443,8888,9999
 ├─ k3d server-0 (k3s node)       → cluster networking + pods
 │   ├─ Traefik (ingress on :80/:443)
 │   ├─ CoreDNS (cluster DNS)
 │   ├─ ServiceLB (klipper-lb for LoadBalancer)
 │   └─ Hindsight pod (:8888 api, :9999 control-plane)
 └─ local-path-provisioner (PVC storage)
```

## Hindsight Resources

| Resource | Details |
|----------|---------|
| Namespace | `hindsight` |
| Secret | `hindsight-env` (from `.env`) |
| PVC | `hindsight-data` (10Gi, local-path) |
| Deployment | `hindsight` (1 replica, 500m–2000m CPU, 1Gi–4Gi RAM) |
| Service | LoadBalancer (8888→api, 9999→control-plane) |

## Key Commands

```bash
# Cluster
k3d cluster list
k3d cluster stop/start/delete dev-cluster

# Hindsight
kubectl get pods -n hindsight
kubectl logs -f deployment/hindsight -n hindsight
kubectl scale deployment/hindsight --replicas=0 -n hindsight

# Debug
kubectl describe pod -n hindsight <pod>
kubectl get events -A --sort-by='.lastTimestamp'
```
