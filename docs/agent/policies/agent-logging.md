---
title: "Agent Logging Policy"
summary: "Defines how AI agents must log automated activity under .agent/log/ so humans can reconstruct what was done and why."
type: "policy"
scope: "repo"
tags:
  - "agent"
  - "logging"
  - "documentation"
related:
  - "always-link.md"
  - "general-instructions.md"
  - "agent-workspace.md"
  - "../../policies/log-file-naming-and-location.md"
  - "../../policies/log-content-guidelines.md"
  - "../../policies/log-entry-format.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-25"
canonical_url: "docs/agent/policies/agent-logging.md"
---

> Source: Derived from the logging section of the previous combined policy `agent-working-directory-and-logging.md` and the detailed logging policies under `docs/policies/`.

# Agent Logging Policy

Every non-trivial agent run must produce a concise log entry in `./.agent/log/` so that humans can reconstruct what was done and why.

This policy defines **what must be logged**, **where logs live**, and **how they are formatted**. It is the agent-facing entrypoint for the repository's logging standards.

## What must be logged

Agents **must** write a log entry when they:

- Modify documentation or code in a way that would normally require a human PR.
- Perform a multi-step refactor or apply scripted changes across multiple files.
- Run automated inventory, classification, or audit workflows that update `docs/` outputs.
- Change CI, Molecule, Terraform, or other infrastructure-related configuration.

Very small, obviously-local edits (for example, fixing a single typo) **may** be grouped into a broader log entry, but should still be covered by some log when part of an automated run.

## Log location and naming

Log files **must** follow the directory and naming scheme defined in:

- `docs/policies/log-file-naming-and-location.md`

In summary:

- All agent logs live under `.agent/log/`.
- Filenames must encode at least a timestamp and a short, human-readable slug.
- Do not place logs in arbitrary directories or mix them with source files.

## Log content requirements

Log entries must be:

- **Brief** – enough context to understand what changed and why, not a full diff.
- **Structured** – follow the standard entry format so tools can parse logs.
- **Honest** – accurately describe what actions were taken and any failures encountered.

Content rules and examples are defined in:

- `docs/policies/log-content-guidelines.md`
- `docs/policies/log-entry-format.md`

Agents should treat those documents as canonical for the exact fields and wording.

## Relationship to workspace policy

This logging policy assumes that:

- Transient files and generated artifacts are written under `.agent/`, especially `.agent/tmp/`.
- Long-lived documentation artifacts (for example, `docs/inventory.yaml`, `docs/classified.yaml`, `docs/audit.json`) are maintained under `docs/`.

The workspace rules and `.agent/` directory layout are defined in:

- `docs/agent/policies/agent-workspace.md`

## Updating logging behavior

When you need to change how logging works:

1. Update this policy to describe the new expectations for agents.
2. Update the underlying repository-wide logging policies under `docs/policies/` as needed.
3. Update any helper scripts that create logs so they remain consistent with this document.

Avoid sprinkling ad hoc logging rules into individual scripts; keep the canonical behavior defined here and in the shared logging policies.