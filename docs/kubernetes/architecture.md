---
title: "Kubernetes Cluster Architecture"
summary: "Architecture overview of the local k3d Kubernetes cluster setup, including container runtime, networking, and storage components."
type: "concept"
scope: "repo"
tags:
  - "kubernetes"
  - "k3d"
  - "architecture"
  - "docker"
related:
  - "kubernetes/README.md"
  - "kubernetes/quickstart.md"
  - "../roles/kubernetes/README.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2026-03-24"
canonical_url: "docs/k8s/architecture.md"
---

# Kubernetes Cluster Architecture

This document describes the architecture of the local Kubernetes cluster provisioned using k3d.

## Overview

```mermaid
graph TB
    subgraph "Host System"
        Docker[(Docker<br/>Container Runtime)]
        Ansible[Ansible<br/>Playbooks]
    end

    subgraph "k3d Cluster"
        subgraph "Control Plane"
            API[API Server]
            etcd[etcd]
            CM[Controller<br/>Manager]
            SM[Scheduler]
        end

        subgraph "Worker Nodes"
            K3S[K3s Agent<br/>kubelet<br/>kube-proxy]
            Pod1[nginx Pod]
            Pod2[Sample App Pod]
        end

        subgraph "Add-ons"
            Traefik[Traefik<br/>Ingress Controller]
            CoreDNS[CoreDNS]
        end
    end

    Docker --> K3S
    Ansible -->|"k3d commands"| Docker
    API --> etcd
    API --> CM
    API --> SM
    API --> K3S
    Traefik --> API
    CoreDNS --> API
```

## Components

### Control Plane (Server Node)

| Component | Description | Image |
|-----------|-------------|-------|
| **kube-apiserver** | REST API for Kubernetes | k3s |
| **etcd** | Distributed key-value store | k3s |
| **kube-scheduler** | Assigns pods to nodes | k3s |
| **kube-controller-manager** | Runs controller loops | k3s |

### Worker Nodes (Agent Nodes)

| Component | Description |
|-----------|-------------|
| **kubelet** | Agent that manages containers on the node |
| **kube-proxy** | Network proxy for service connectivity |
| **containerd** | Container runtime (embedded in k3s) |

### Add-ons

| Add-on | Purpose |
|--------|---------|
| **Traefik** | Ingress controller for HTTP/HTTPS routing |
| **CoreDNS** | DNS-based service discovery |
| **Metrics Server** | Resource metrics collection |

## Network Architecture

```mermaid
graph LR
    subgraph "Host Network"
        Client[Client<br/>kubectl/helm]
    end

    subgraph "Docker Network"
        subgraph "k3d cluster: dev-cluster"
            LB[Traefik<br/>:80 :443]
            Node1[Server Node]
        end
    end

    Client -->|"kubeconfig"| LB
    LB -->|":80 :443"| Node1
```

### Port Mappings

| Host Port | Service | Description |
|-----------|---------|-------------|
| 80 | Traefik | HTTP ingress |
| 443 | Traefik | HTTPS ingress |
| 6443 | API Server | Kubernetes API (internal) |

## Storage

### Ephemeral Storage
- Default: Container images and layers stored in Docker's storage driver
- Suitable for development and testing

### Persistent Storage
- Requires CSI driver configuration
- For production workloads, configure:
  - Local PV (HostPath)
  - NFS
  - Cloud provider CSI

## Security Considerations

### Network Policies
- Default: All pods can communicate
- Restrict with NetworkPolicy resources

### RBAC
- Default: Cluster-admin for local development
- Production: Implement Role/RoleBinding

### Secrets
- Default: Stored as base64 (not encrypted)
- Production: Use external secrets manager

## High Availability (Optional)

For production-like environments, scale the cluster:

```yaml
k3d_server_nodes: 3    # Multiple control plane nodes
k3d_worker_nodes: 2   # Worker nodes for workloads
```

## Related Documentation

- [Quickstart Guide](quickstart.md) - Setup instructions
- [Sample Application](sample-app.md) - Deployment walkthrough
- [Operations](operations.md) - Common operations
