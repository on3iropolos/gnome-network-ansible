---
title: "Agent Workspace Policy (.agent/)"
summary: "Defines how AI agents must use the .agent/ directory as a workspace for temporary artifacts and tooling."
type: "policy"
scope: "repo"
tags:
  - "agent"
  - "workspace"
  - "documentation"
related:
  - "always-link.md"
  - "general-instructions.md"
  - "agent-logging.md"
  - "../../policies/working-directory.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-25"
canonical_url: "docs/agent/policies/agent-workspace.md"
---

> Source: Derived from the previous combined policy `agent-working-directory-and-logging.md` and the legacy `.agent/instructions/working_directory.md`.

# Agent Workspace Policy

Agents must treat the `./.agent/` directory as the dedicated workspace for automated activity in this repository.

## What belongs in .agent/

The `.agent/` directory is the home for:

- Transient working files (intermediate JSON/YAML, scratch notes, audit outputs).
- Agent-oriented scripts and helper tools under `.agent/`.
- Temporary materials generated while running documentation or refactor workflows.

Key rules:

- Do not scatter temporary files across the repository; keep them under `.agent/`.
- Respect the project’s `.gitignore` rules so ephemeral outputs (for example `.agent/tmp/`) are not committed.
- Instruction and policy files under `.agent/instructions/` and `docs/agent/policies/` remain version-controlled; everything under `.agent/tmp/` is considered ephemeral.

For additional repository-wide rules about working directories, see [`working-directory.md`](../../policies/working-directory.md:1).

## Ephemeral vs canonical content

- Files under `.agent/tmp/` are treated as design inputs and scratch space only.
- If a unit sourced from `.agent/tmp/` is chosen to remain as part of the long-term documentation, its canonical doc must live under `docs/` following the normal subject/slug rules.
- Otherwise, `.agent/tmp/` content is considered non-canonical and may be deleted or ignored in future runs.

## Relationship to other policies

- Logging requirements for agent runs are defined in [`agent-logging.md`](agent-logging.md:1).
- The Always Link documentation model is defined in [`always-link.md`](always-link.md:1).
- General expectations for agent behavior are defined in [`general-instructions.md`](general-instructions.md:1).