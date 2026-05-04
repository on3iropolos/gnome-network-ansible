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

```mermaid
graph TD
    Host[Host]
    LB[k3d serverlb<br/>nginx proxy<br/>:80 :443 :8888 :9999]
    Server[k3d server-0<br/>k3s node]
    Traefik[Traefik<br/>ingress :80/:443]
    CoreDNS[CoreDNS]
    ServiceLB[ServiceLB<br/>klipper-lb]
    Hindsight[Hindsight pod<br/>:8888 api :9999 ui]
    Storage[local-path-provisioner<br/>PVC storage]

    Host --> LB
    Host --> Server
    Server --> Traefik
    Server --> CoreDNS
    Server --> ServiceLB
    Server --> Hindsight
    Server --> Storage
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
