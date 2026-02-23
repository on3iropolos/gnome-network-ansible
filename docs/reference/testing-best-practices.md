---
title: "Testing and linting best practices"
summary: "Repository-wide expectations and practical guidance for ansible-lint, Molecule role tests, and manual testing."
type: "reference"
scope: "repo"
tags:
  - "testing"
  - "linting"
  - "ansible-lint"
  - "molecule"
  - "ci"
related:
  - "../troubleshooting/troubleshooting-molecule.md"
  - "../contributing.md"
owner: "docs-maintainers"
last_reviewed: "2025-11-19"
canonical_url: "docs/reference/testing-best-practices.md"
source: "docs/policies/testing-and-linting.md"
---

# Testing and linting best practices

> Source: This reference was migrated from the former "Testing and linting policy" that previously lived under `docs/policies/testing-and-linting.md`.

This document explains how testing and linting are expected to be used in this repository. It is the central reference for ansible-lint usage, Molecule testing expectations, and manual testing guidance.

## ansible-lint

This repository uses `ansible-lint` for static analysis of Ansible content.

- A GitHub Actions workflow at [`.github/workflows/ansible-lint.yml`](../../.github/workflows/ansible-lint.yml:1) automatically runs `ansible-lint .` on pull requests targeting the `main` branch.
- Your changes SHOULD pass these automated linting checks. If the CI check fails, fix the reported issues and push corrections.
- The project [`Dockerfile`](../../Dockerfile:1) includes `ansible-lint`, which you can use for local testing.
- You are strongly encouraged to run `ansible-lint .` locally from the repository root (inside the provided container image or an equivalent local environment) before opening a pull request.
- Address critical errors and relevant warnings. If a rule seems in conflict with your task, discuss it in the pull request rather than ignoring it silently.
- Repository-specific rules may be configured via [`.ansible-lint`](../../.ansible-lint:1); when present, they are authoritative.

### Recommended local workflow

1. Use a development environment that matches CI as closely as possible (for example the container image defined in the [`Dockerfile`](../../Dockerfile:1)).
2. From the repository root, run:

   ```bash
   ansible-lint .
   ```

3. Fix any reported issues that apply to your changes.
4. Re-run `ansible-lint .` until it passes before pushing your branch.

## Molecule role testing

This repository uses Molecule with Docker for automated role testing.

- A GitHub Actions workflow at [`.github/workflows/molecule-test.yml`](../../.github/workflows/molecule-test.yml:1) runs Molecule tests for roles on pull requests.
- When you create or modify a role, you SHOULD add or update Molecule tests covering the intended behavior.
- Running Molecule tests locally before submitting changes is strongly recommended, especially for complex roles.

### Standard Molecule layout for roles

Each role that uses Molecule typically has:

- `roles/<role-name>/molecule/default/` – default scenario directory
- `molecule.yml` – scenario configuration (platforms, drivers, provisioner)
- `Dockerfile.j2` – image build template for the test container
- `prepare.yml` – playbook to prepare the test environment (for example, install Python)
- `converge.yml` – playbook that applies the role under test
- `verify.yml` – playbook that verifies the role behaved correctly

### Running Molecule locally

From the role directory:

```bash
cd roles/<role-name>
molecule test          # Run full test sequence
molecule converge      # Apply role to test container
molecule verify        # Run verification tests
molecule destroy       # Clean up test containers
```

Molecule tests SHOULD verify at least:

- Package installation and versions, where relevant
- Service states (started/stopped, enabled/disabled)
- File creation and contents
- Configuration correctness
- Idempotency – running the role repeatedly should not produce changes after the first successful run

For deeper troubleshooting of Molecule issues, see [`troubleshooting-molecule`](../troubleshooting/troubleshooting-molecule.md:1).

## Manual testing expectations

Automated checks do not replace thoughtful manual testing. Always consider how your changes behave in realistic environments.

- Use Docker containers, VMs, or physical systems that resemble target hosts.
- When appropriate, document useful manual test procedures in role READMEs or troubleshooting docs rather than burying them in commit messages.
- In pull requests, briefly describe what manual testing you performed and on which platforms.

If you have suggestions for new automated or manual tests that would catch bugs earlier, capture them in relevant docs (for example role documentation or troubleshooting runbooks) and reference them from your pull request.