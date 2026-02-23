---
title: "Troubleshooting Molecule with Docker"
summary: "Runbook for diagnosing and fixing common Molecule + Docker issues in this repository."
type: "runbook"
scope: "repo"
tags:
  - "molecule"
  - "docker"
  - "testing"
  - "troubleshooting"
  - "ansible"
related:
  - "../reference/testing-best-practices.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-19"
canonical_url: "docs/troubleshooting/troubleshooting-molecule.md"
---

# Troubleshooting Molecule with Docker

This runbook covers common failures when running Molecule tests with Docker in this repository and how to fix them quickly. It assumes you are using the standard development workflow described in the project [README](../../README.md).

## Prerequisites

- Docker is installed on your system.
- You have cloned the repository and installed Python dependencies from `requirements.txt`.
- You are running Molecule from within the project root or the appropriate role directory.

## Scenario 1: Docker permission errors

**Symptom**

- `permission denied while trying to connect to the Docker daemon socket`
- Molecule commands fail immediately.

**Fix**

```bash
sudo usermod -aG docker $USER
# Log out and log back in for group changes to take effect
```

After re-login, verify:

```bash
groups | grep docker
docker info | head -5
```

If you are using Docker Desktop (macOS/Windows), ensure the Docker Desktop application is running.

## Scenario 2: Docker daemon not running

**Symptom**

- `Cannot connect to the Docker daemon`
- `Error response from daemon`

**Fix (Linux)**

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

**Fix (macOS/Windows)**

- Start Docker Desktop and wait until it reports that Docker is running.

Re-run your Molecule command:

```bash
cd roles/network
molecule test
```

## Scenario 3: Tests failing in CI/CD

**Symptom**

- GitHub Actions `molecule-test` or `ansible-lint` jobs are red.

**Fix**

1. Open the GitHub Actions "Actions" tab for this repository.
2. Locate the failing workflow run and expand the failing job.
3. Inspect the Molecule step output or ansible-lint messages.
4. Reproduce locally using the same commands (for example `molecule test` in the affected role or `ansible-lint .` at repo root).
5. Fix the underlying issue (role logic, tests, or lint violations) and re-run locally before pushing.

## Verification

After applying a fix, verify that:

- `docker info` runs without permission errors.
- `molecule test` completes successfully for the target role.
- CI workflows for `ansible-lint` and `molecule-test` pass on your branch.

## Source

This runbook is derived from the Molecule troubleshooting guidance that originally lived in `DEVELOPMENT.md` under "Troubleshooting Molecule".