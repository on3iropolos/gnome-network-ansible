---
title: "Agent Commands Index"
summary: "Index of agent-facing commands for working with documentation and policies in this repository."
type: "reference"
scope: "repo"
tags:
  - "agent"
  - "commands"
  - "documentation"
related:
  - "../INDEX.md"
  - "../policies/INDEX.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2026-04-29"
canonical_url: "docs/agent/commands/INDEX.md"
---

# Agent Commands Index

This index lists the primary commands that AI agents should use when working with documentation and policies in this repository.

## Working directory and logging

When running automated agent tasks:

- Follow the agent workspace policy in [`agent-workspace.md`](../policies/agent-workspace.md:1).
- Follow the agent logging policy in [`agent-logging.md`](../policies/agent-logging.md:1).
- Keep all temporary outputs under `.agent/tmp/`.
- Record a concise log entry for non-trivial runs under `.agent/log/` using the naming and content guidelines in:
  - [`../../policies/log-file-naming-and-location.md`](../../policies/log-file-naming-and-location.md:1)
  - [`../../policies/log-content-guidelines.md`](../../policies/log-content-guidelines.md:1)
  - [`../../policies/log-entry-format.md`](../../policies/log-entry-format.md:1)
