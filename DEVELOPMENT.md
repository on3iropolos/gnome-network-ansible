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

## Quality Assurance

To ensure code quality, this project uses `pre-commit` hooks. These hooks run automatically before every commit to catch linting issues, validation errors, and formatting problems.

### Setup
Run the following command to install the pre-commit hooks:
```bash
make setup
```

This will configure hooks for `ansible-lint`, `shellcheck`, and general file hygiene.

### Manual Run
You can run the hooks manually on all files at any time:
```bash
pre-commit run --all-files
```

## CI and best practices

CI workflows and testing best practices are described in:

- [`docs/reference/testing-best-practices.md`](docs/reference/testing-best-practices.md:1)

Always treat the `docs/` tree as canonical. This file remains a lightweight index to avoid duplicating content.
