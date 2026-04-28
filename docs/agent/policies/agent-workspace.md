---
title: "Agent Workspace Policy (.agent/)"
summary: "Policy for using .agent/ as workspace for working files and ephemeral outputs."
type: "policy"
scope: "repo"
tags:
  - "agent"
  - "workspace"
  - "documentation"
related:
  - "agent-operational-policies.md"
  - "general-instructions.md"
  - "always-link.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2026-04-28"
---

# Agent Workspace Policy

This file defines how AI agents must use the repository-local `.agent/` directory as their workspace for ephemeral files.

For current expectations, including issue tracking with bd (beads), see [`Agent Operational Policies`](agent-operational-policies.md:1).

## Rules

1. **Ephemeral only:** `.agent/` is for working files, scratch space, and logs only.
2. **No memory storage:** Long-term memory now lives in Beads (`.beads/`). Do NOT use `.agent/` for persistent memory.
3. **Version control:** Files under `.agent/` are NOT committed (see `.gitignore`).
4. **Cleanup:** Agents should clean up `.agent/tmp/` periodically.