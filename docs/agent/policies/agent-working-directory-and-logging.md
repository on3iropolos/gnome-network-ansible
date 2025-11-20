---
title: "Agent Working Directory and Logging"
summary: "Defines how AI agents must use the .agent/ working directory and how to structure logging for automated activity in this repository."
type: "policy"
scope: "repo"
tags:
  - "agent"
  - "logging"
  - "documentation"
related:
  - "../../policies/working-directory.md"
  - "../../policies/logging.md"
  - "../../policies/log-file-naming-and-location.md"
  - "../../policies/log-content-guidelines.md"
  - "../../policies/log-entry-format.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-19"
canonical_url: "docs/agent/policies/agent-working-directory-and-logging.md"
---

> Source: This policy was migrated from [`docs/policies/agent-working-directory-and-logging.md`](../../policies/agent-working-directory-and-logging.md:1) to be part of the agent documentation collection under `docs/agent/`.

# Agent Working Directory and Logging

This policy describes how AI agents must use the `.agent/` directory for temporary artifacts and how they must log activity in this repository. It consolidates and replaces the older inline instructions in `.agent/instructions/working_directory.md` and should be treated as the canonical reference.

## Working directory overview

Agents must treat the `./.agent/` directory as the dedicated workspace for:

- Transient working files (intermediate JSON/YAML, scratch notes, audit outputs).
- Agent-oriented scripts and helper tools under `.agent/`.
- Logs written during automated documentation or refactor runs.

Key points:

- Do not scatter temporary files across the repository; keep them under `.agent/`.
- Respect the project’s `.gitignore` rules so that ephemeral outputs (for example `.agent/tmp/`) are not committed.
- Instruction files under `.agent/instructions/` remain version-controlled; everything under `.agent/tmp/` is considered ephemeral.

For more detail on the working directory rules, see [`working-directory.md`](../../policies/working-directory.md:1).

## Logging overview

Every non-trivial agent run must produce a concise log entry in `./.agent/log/` so that humans can reconstruct what was done and why.

Logging requirements:

- Use the directory and naming scheme described in [`log-file-naming-and-location.md`](../../policies/log-file-naming-and-location.md:1).
- Follow the content and brevity rules from [`log-content-guidelines.md`](../../policies/log-content-guidelines.md:1).
- Use the standard entry format from [`log-entry-format.md`](../../policies/log-entry-format.md:1) so logs remain machine- and human-readable.

Logging is not optional; it is part of the required audit trail for automated changes to documentation and code.

## Relationship to other policies

- The ALWAYS LINK documentation rules are defined at [`always-link.md`](always-link.md:1) and govern how canonical docs and link stubs are organized.
- General agent behavior (following user instructions, respecting testing policies, and using `.agent` tooling) is defined in [`general-instructions.md`](general-instructions.md:1).
- This document adds specific requirements for:
  - Where agents create transient files.
  - How they name and structure logs.
  - How they keep logging concise but useful.

When updating logging or working-directory behavior, prefer to update this policy and the related detailed docs rather than editing individual scripts in isolation.

## Migration note

The original guidance in `.agent/instructions/working_directory.md` has been canonicalized into this document and its related policies. Future references to working-directory or logging behavior should link here or to the more focused docs listed in `related`, not to the legacy `.agent/instructions/` file.