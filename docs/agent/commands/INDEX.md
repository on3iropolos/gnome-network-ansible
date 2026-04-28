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
last_reviewed: "2026-02-23"
canonical_url: "docs/agent/commands/INDEX.md"
---

# Agent Commands Index

This index lists the primary commands and scripts that AI agents should use when working with documentation and policies in this repository. It complements the workflow described in [`docs/agent/workflows/update-docs.md`](../workflows/update-docs.md:1).

## Documentation Commands

Use these commands (type `/` followed by the command name):

### /doc-inventory

- Command file: [doc-inventory](../../../.opencode/commands/doc-inventory.md)
- Script: `.opencode/scripts/inventory.py`
- Purpose: Scans markdown documentation and produces an inventory of "documentation units" with signatures and source pointers.
- Usage: `/doc-inventory` or `python3 .opencode/scripts/inventory.py`
- Output: Writes to `.agent/tmp/inventory.yaml` (ephemeral)

### /doc-classify

- Command file: [doc-classify](../../../.opencode/commands/doc-classify.md)
- Script: `.opencode/scripts/classify.py`
- Purpose: Consumes the inventory output and classifies units by subject, type, scope, and tags
- Usage: `/doc-classify` or `python3 .opencode/scripts/classify.py`
- Output: Writes to `.agent/tmp/classified.yaml` (ephemeral)

### /doc-audit

- Command file: [doc-audit](../../../.opencode/commands/doc-audit.md)
- Script: `.opencode/scripts/audit.py`
- Purpose: Audits links across docs for broken links, oversize docs, and duplicates
- Usage: `/doc-audit` or `python3 .opencode/scripts/audit.py`
- Output: Writes to `.agent/tmp/audit.json` (ephemeral) and `docs/audit.json`

## Agent Skills

For the complete documentation workflow, use the [update-docs](../../../.opencode/skills/update-docs/SKILL.md) skill:

```
skill({ name: "update-docs" })
```

Other available skills:

- [canonical-docs](../../../.opencode/skills/canonical-docs/SKILL.md): Always Link policy
- [agent-instructions](../../../.opencode/skills/agent-instructions/SKILL.md): General agent rules

## Working directory and logging

When running any of these commands as part of an automated agent task:

- Follow the agent workspace policy in [`agent-workspace.md`](../policies/agent-workspace.md:1).
- Follow the agent logging policy in [`agent-logging.md`](../policies/agent-logging.md:1).
- Keep all temporary outputs under `.agent/tmp/` (ephemeral).
- Record a concise log entry for non-trivial runs under `.agent/log/` using the naming and content guidelines in:
  - [`../../policies/log-file-naming-and-location.md`](../../policies/log-file-naming-and-location.md:1)
  - [`../../policies/log-content-guidelines.md`](../../policies/log-content-guidelines.md:1)
  - [`../../policies/log-entry-format.md`](../../policies/log-entry-format.md:1)
