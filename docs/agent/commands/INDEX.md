---
title: "Agent Commands Index"
summary: "Index of agent-facing commands and scripts for working with documentation and policies in this repository."
type: "reference"
scope: "repo"
tags:
  - "agent"
  - "commands"
  - "documentation"
related:
  - "../INDEX.md"
  - "../workflows/update-docs.md"
  - "../policies/INDEX.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-20"
canonical_url: "docs/agent/commands/INDEX.md"
---

# Agent Commands Index

This index lists the primary commands and scripts that AI agents should use when working with documentation and policies in this repository. It complements the workflow described in [`docs/agent/workflows/update-docs.md`](../workflows/update-docs.md:1).

All commands referenced here live under the `.agent/` directory and should be treated as tooling, not canonical documentation.

## Documentation tooling

### Inventory generator

- Script: [`doc_inventory.py`](../../../.agent/doc_inventory.py:1)  
- Purpose: Scans markdown documentation and produces an inventory of “documentation units” with signatures and source pointers.  
- Typical usage:

  ```bash
  python3 .agent/doc_inventory.py
  ```

- Output: Writes an inventory file under `.agent/tmp/` (ephemeral working data).

### Classifier

- Script: [`doc_classify.py`](../../../.agent/doc_classify.py:1)  
- Purpose: Consumes the inventory output and classifies units by subject, type, scope, and tags; also records canonical-doc mappings and duplicates.  
- Typical usage:

  ```bash
  python3 .agent/doc_classify.py
  ```

- Output: Writes a classified report under `.agent/tmp/` (ephemeral working data).

### Link auditor

- Script: [`doc_audit.py`](../../../.agent/doc_audit.py:1)  
- Purpose: Audits links across `docs/`, `README.md`, and `AGENTS.md` for:
  - Broken or invalid links.
  - Oversize docs that may need splitting.
  - Duplicate or ambiguous canonical docs.
- Typical usage:

  ```bash
  python3 .agent/doc_audit.py
  ```

- Output: Writes an audit report under `.agent/tmp/audit.json` (ephemeral working data).

## Working directory and logging

When running any of these commands as part of an automated agent task:

- Follow the agent workspace policy in [`agent-workspace.md`](../policies/agent-workspace.md:1).
- Follow the agent logging policy in [`agent-logging.md`](../policies/agent-logging.md:1).
- Keep all temporary outputs under `.agent/tmp/`.
- Record a concise log entry for non-trivial runs under `.agent/log/` using the naming and content guidelines in:
  - [`../../policies/log-file-naming-and-location.md`](../../policies/log-file-naming-and-location.md:1)
  - [`../../policies/log-content-guidelines.md`](../../policies/log-content-guidelines.md:1)
  - [`../../policies/log-entry-format.md`](../../policies/log-entry-format.md:1)