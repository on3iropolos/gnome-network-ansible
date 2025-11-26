---
title: "Agent Working Directory"
summary: "Defines how AI agents must use the .agent/ directory as the central workspace for transient files, instructions, and tooling."
type: "policy"
scope: "repo"
tags:
  - "agent"
  - "working-directory"
  - "tooling"
related:
  - "agent-workspace.md"
  - "agent-logging.md"
  - "../../policies/logging.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-19"
canonical_url: "docs/agent/policies/working-directory.md"
---

> Source: This policy was migrated from [`docs/policies/working-directory.md`](../../policies/working-directory.md:1) to make it part of the agent documentation collection under `docs/agent/policies/`.

# Agent Working Directory

Agents must treat the `./.agent/` directory as the dedicated workspace for transient files, instructions, and automation tooling. This policy is the canonical reference for where agents are allowed to write working artifacts. Higher-level guidance is summarized in [`agent-workspace.md`](agent-workspace.md:1) and [`agent-logging.md`](agent-logging.md:1).

## Directory usage

- **Location:** All transient agent files **must** live under the repository-local `.agent/` directory.
- **Tracked vs. untracked:**
  - Instruction and tooling files (for example `.agent/instructions/*.md`, `.agent/*.py`) are version-controlled.
  - Ephemeral outputs (for example `.agent/tmp/`, generated inventories, audits, scratch notes) may be untracked and are governed by `.gitignore`.
- **No stray artifacts:** Do not write temporary YAML, JSON, or logs into role directories, `docs/`, or the repository root.

This convention keeps human-authored source clean while giving agents a clear, isolated workspace.

## Subdirectories

Typical layout under `.agent/`:

- `.agent/instructions/` – long-lived, versioned instructions for agents.
- `.agent/tmp/` – scratch space for inventories, classifications, audits, and other ephemeral outputs.
- `.agent/log/` – structured daily logs of agent activity (see the logging policies under [`docs/policies/logging.md`](../../policies/logging.md:1)).

Agents must respect this structure; new tools or scripts should also place any temporary files under `.agent/tmp/` instead of creating new ad-hoc directories elsewhere.