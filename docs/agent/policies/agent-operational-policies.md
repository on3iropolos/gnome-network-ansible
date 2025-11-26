---
title: "Agent Operational Policies"
summary: "Combined workspace, working-directory, and logging rules for AI agents using the .agent/ area and repository logging standards."
type: "policy"
scope: "repo"
tags:
  - "agent"
  - "workspace"
  - "working-directory"
  - "logging"
related:
  - "always-link.md"
  - "general-instructions.md"
  - "agent-workspace.md"
  - "agent-logging.md"
  - "working-directory.md"
  - "../../policies/log-file-naming-and-location.md"
  - "../../policies/log-content-guidelines.md"
  - "../../policies/log-entry-format.md"
  - "../../policies/working-directory.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-25"
canonical_url: "docs/agent/policies/agent-operational-policies.md"
---

> Source: Consolidates the earlier `agent-workspace`, `agent-logging`, and `working-directory` agent policies into a single canonical document.

# Agent Operational Policies

This document defines how AI agents must use the repository-local `.agent/` directory as their workspace and how they must log non-trivial activity. It is the single canonical reference for workspace, working-directory, and logging behavior at the agent level. Repository-wide logging details still live under [`docs/policies/INDEX.md`](docs/policies/INDEX.md:1).

## 1. Workspace and working directory

- **Workspace root:** All transient agent files **must** live under the repository-local `.agent/` directory.
- **No stray artifacts:** Do not write temporary YAML, JSON, logs, or scratch files into roles, `docs/`, or the repo root.
- **Tracked vs untracked:**
  - Version-controlled instructions and tools live under `.agent/` (for example `.agent/instructions/*.md`, `.agent/*.py`).
  - Ephemeral outputs (for example inventories, audits, scratch notes) live under `.agent/tmp/` and are governed by `.gitignore`.
- **Working directory:** Commands in this repository are assumed to run from the repository root; any temporary files they create must still be placed under `.agent/`.

Typical layout:

- `.agent/instructions/` – long-lived, versioned instructions for agents.
- `.agent/tmp/` – scratch space for inventories, classifications, audits, and other ephemeral outputs.
- `.agent/log/` – structured logs of non-trivial agent activity.

These conventions keep human-authored source clean while giving agents a clear, isolated workspace.

## 2. Ephemeral vs canonical content

- Files under `.agent/tmp/` are design inputs and scratch space only.
- If a unit sourced from `.agent/tmp/` should become long-term documentation, its canonical doc **must** live under `docs/<subject>/<slug>.md` with proper front matter.
- Do not treat `.agent/tmp/` as a permanent storage area; it may be cleaned up or regenerated at any time.

## 3. Logging requirements

Every non-trivial agent run must produce a concise log entry in `.agent/log/` so that humans can reconstruct what was done and why.

Agents **must** log when they:

- Modify documentation or code in a way that would normally require a human PR.
- Perform multi-step refactors or scripted changes across multiple files.
- Run inventory, classification, or audit workflows that update `docs/` outputs.
- Change CI, Molecule, Terraform, or other infrastructure-related configuration.

Very small, obviously local edits (for example, fixing a single typo) may be grouped into a broader log entry but should still be covered by some log when part of an automated run.

### 3.1 Log location and naming

- All agent logs live under `.agent/log/`.
- Filenames must follow the repository's logging standards so they encode at least a timestamp and a short, human-readable slug.
- Do not place logs in arbitrary directories or mix them with source files.

See the canonical logging policies for exact rules:

- [`docs/policies/log-file-naming-and-location.md`](docs/policies/log-file-naming-and-location.md:1)
- [`docs/policies/log-content-guidelines.md`](docs/policies/log-content-guidelines.md:1)
- [`docs/policies/log-entry-format.md`](docs/policies/log-entry-format.md:1)

### 3.2 Log content

Log entries must be:

- **Brief** – enough context to understand what changed and why, not a full diff.
- **Structured** – follow the standard entry format so tools can parse logs.
- **Honest** – accurately describe what actions were taken and any failures encountered.

## 4. Updating operational behavior

When you need to change how workspace or logging behaves for agents:

1. Update this document to reflect the new expectations.
2. Update any underlying repository-wide logging policies under `docs/policies/` as needed.
3. Update helper scripts under `.agent/` so their behavior matches this policy.

Avoid sprinkling ad hoc workspace or logging rules into individual scripts; keep the canonical behavior defined here and reference it from other docs using short link stubs.