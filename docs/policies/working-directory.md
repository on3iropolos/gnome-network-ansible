---
title: "Working directory and logging index"
summary: "Index of canonical policies and references describing how the repository and agents use the .agent/ working directory and where logs must be written."
type: "reference"
scope: "repo"
tags:
  - "agent"
  - "working-directory"
  - "logging"
related:
  - "logging.md"
  - "log-file-naming-and-location.md"
  - "log-content-guidelines.md"
  - "log-entry-format.md"
  - "../agent/policies/agent-working-directory-and-logging.md"
  - "../agent/policies/working-directory.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-20"
canonical_url: "docs/policies/working-directory.md"
source: ".agent/instructions/working_directory.md"
---

# Working directory and logging index

This file is an index for working-directory and logging behavior. It replaces the former “Agent Working Directory” policy under `docs/policies/working-directory.md` with a set of smaller, focused docs.

Use the docs linked here as the canonical references for:

- Where temporary files and logs may be written.
- How agents must use the `.agent/` directory.
- How log files are named, located, and structured.

## Repository-wide logging policies

These policies apply to all tooling and humans writing logs in this repository:

- [`Logging policy`](logging.md:1)  
  High-level expectations for logging in this repository.

- [`Log file naming and location`](log-file-naming-and-location.md:1)  
  Where log files must live and how they are named.

- [`Log content guidelines`](log-content-guidelines.md:1)  
  What logs should (and should not) contain.

- [`Log entry format`](log-entry-format.md:1)  
  Required structure for individual log entries so they remain machine- and human-readable.

## Agent-focused working directory and logging

Agent-specific behavior is defined under `docs/agent/policies/`:

- [`Agent working directory and logging`](../agent/policies/agent-working-directory-and-logging.md:1)  
  Canonical policy describing:
  - Overall use of `.agent/` for transient artifacts.
  - Relationship between agent logs and the general logging policies above.
  - Requirements for creating log entries during automated runs.

- [`Agent working directory`](../agent/policies/working-directory.md:1)  
  Detailed policy for how agents must use the `.agent/` directory:
  - All transient agent files live under `.agent/`.
  - Separation between versioned instructions and ephemeral outputs.
  - Recommended subdirectory layout (`.agent/instructions/`, `.agent/tmp/`, `.agent/log/`).

## Using this index

When you introduce new tools or workflows that write temporary files or logs:

1. Consult the repository-wide logging policies to ensure you respect naming, location, and content rules.
2. For agent automation, follow the agent working-directory and logging policies under `docs/agent/policies/`.
3. Add any new, focused docs (for example, a how-to for a new log-processing tool) under `docs/` and link them from this index rather than expanding this file into a monolithic policy.