---
title: "Testing and linting documentation index"
summary: "Index of canonical docs covering ansible-lint usage, Molecule role testing, Terraform VM testing, and manual testing expectations."
type: "reference"
scope: "repo"
tags:
  - "testing"
  - "linting"
  - "ansible-lint"
  - "molecule"
  - "ci"
related:
  - "../reference/testing-best-practices.md"
  - "../troubleshooting/troubleshooting-molecule.md"
  - "../terraform/testing-with-terraform-libvirt.md"
  - "../contributing.md"
owner: "docs-maintainers"
last_reviewed: "2025-11-20"
canonical_url: "docs/policies/testing-and-linting.md"
source: ".agent/instructions/testing_and_linting.md"
---

# Testing and linting docs

This file is an index for testing- and linting-related documentation. It replaces the former “Testing and linting policy” with a set of smaller, focused docs under `docs/`.

Use the docs linked here as the canonical references for how testing works in this repository.

## Overview and best practices

- [`Testing and linting best practices`](../reference/testing-best-practices.md:1)  
  Central reference for:
  - Running `ansible-lint` locally and in CI.
  - Expected Molecule test coverage and workflows.
  - Manual testing expectations and how to describe testing in pull requests.

## Molecule and container-based testing

- [`Molecule testing (container-based)`](../reference/molecule-testing-container-based.md:1)  
  How to run Molecule tests with Docker, standard scenario layout, and day-to-day workflows.
- [`Troubleshooting Molecule`](../troubleshooting/troubleshooting-molecule.md:1)  
  Runbook for common Molecule + Docker failures and how to debug them.

## VM-based testing with Terraform + libvirt

- [`Terraform VM testing`](../terraform/testing-with-terraform-libvirt.md:1)  
  Full-system VM testing workflows using Terraform and libvirt/KVM, including setup and teardown scripts.
- [`Terraform VM testing troubleshooting`](../troubleshooting/terraform-vm-testing.md:1)  
  Runbook for diagnosing and fixing Terraform/libvirt issues in the VM testing environment.

## Contributing and extending tests

- [`Contributing documentation to Gnome Network Ansible`](../contributing.md:1)  
  Describes the ALWAYS LINK policy, canonical docs, and how to structure new testing docs.

When you add new testing workflows or tools:

- Prefer to create focused docs under `docs/reference/`, `docs/how-to/`, `docs/terraform/`, or `docs/troubleshooting/` as appropriate.
- Link those docs from this index instead of growing this file into a monolithic policy.
- Keep [`docs/reference/testing-best-practices.md`](../reference/testing-best-practices.md:1) as the primary narrative for cross-cutting testing expectations.