---
title: "Agent Operational Policies"
summary: "Workspace, working-directory, logging rules, and issue tracking for AI agents."
type: "policy"
scope: "repo"
tags:
  - "agent"
  - "workspace"
  - "working-directory"
  - "logging"
  - "issue-tracking"
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
last_reviewed: "2026-04-28"
canonical_url: "docs/agent/policies/agent-operational-policies.md"
---

# Agent Operational Policies

This document defines how AI agents must use the repository-local `.agent/` directory as their workspace, how they must log non-trivial activity, and how they must track issues using **bd (beads)**. It is the single canonical reference for workspace, working-directory, logging behavior, and issue tracking at the agent level.

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

- [`../../policies/log-file-naming-and-location.md`](../../policies/log-file-naming-and-location.md:1)
- [`../../policies/log-content-guidelines.md`](../../policies/log-content-guidelines.md:1)
- [`../../policies/log-entry-format.md`](../../policies/log-entry-format.md:1)

### 3.2 Log content

Log entries must be:

- **Brief** – enough context to understand what changed and why, not a full diff.
- **Structured** – follow the standard entry format so tools can parse logs.
- **Honest** – accurately describe what actions were taken and any failures encountered.

## 4. Issue tracking with bd (beads)

This project uses **bd (beads)** for ALL issue tracking and task management.

### 4.1 Core commands

- **Find work:** `bd ready --json` shows unblocked issues
- **Create issues:** `bd create "Title" -t task|bug|feature -p 0-4 --json`
- **Claim work:** `bd update <id> --claim --json`
- **Complete work:** `bd close <id> --reason "Done" --json`
- **Sync:** `bd sync` at session end

### 4.2 Rules

- ✅ Use bd for ALL task tracking
- ✅ Always use `--json` flag for programmatic access
- ✅ Link discovered work with `discovered-from` dependencies
- ✅ Check `bd ready` before asking "what should I work on?"
- ❌ Do NOT create markdown TODO lists
- ❌ Do NOT use external issue trackers
- ❌ Do NOT duplicate tracking systems

### 4.3 Stealth mode

This repository uses **stealth mode** (`bd init --stealth`):
- Beads database lives in `.beads/` (local-only, in `.git/info/exclude`)
- No git hooks installed (`no-git-ops: true`)
- Must manually run `bd sync` at session end

## 5. Updating operational behavior

When you need to change how workspace, logging, or issue tracking behaves for agents:

1. Update this document to reflect the new expectations.
2. Update any underlying repository-wide logging policies under `docs/policies/` as needed.
3. Update helper scripts under `.agent/` so their behavior matches this policy.

Avoid sprinkling ad hoc workspace, logging, or issue-tracking rules into individual scripts; keep the canonical behavior defined here and reference it from other docs using short link stubs.