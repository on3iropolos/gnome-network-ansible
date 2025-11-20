# Development environment and testing

This document now serves as an entrypoint into the canonical documentation for local development and testing. For complete, up-to-date guidance, use the docs under `docs/` as the source of truth.

## Container-based testing with Molecule

Molecule + Docker usage, scenarios, and troubleshooting are documented in:

- [`docs/reference/molecule-testing-container-based.md`](docs/reference/molecule-testing-container-based.md:1)
- [`docs/troubleshooting/troubleshooting-molecule.md`](docs/troubleshooting/troubleshooting-molecule.md:1)
- [`docs/reference/testing-best-practices.md`](docs/reference/testing-best-practices.md:1)

Refer to those docs for:

- Prerequisites (Docker, Python dependencies)
- Standard test sequences and role layout
- Common failure modes and fixes
- Expectations for CI integration and ansible-lint

## VM-based testing with Terraform + libvirt

Full-system VM-based testing (for example, for `arch_iso_install`) is documented in:

- [`docs/terraform/testing-with-terraform-libvirt.md`](docs/terraform/testing-with-terraform-libvirt.md:1)
- [`docs/troubleshooting/terraform-vm-testing.md`](docs/troubleshooting/terraform-vm-testing.md:1)

Those docs cover setup, quick-start workflows, scenarios, and troubleshooting for the Terraform + libvirt environment.

## CI and best practices

CI workflows and testing best practices are described in:

- [`docs/reference/testing-best-practices.md`](docs/reference/testing-best-practices.md:1)

Always treat the `docs/` tree as canonical. This file remains a lightweight index to avoid duplicating content.
