---
title: "Agent Workflow: Updating Documentation"
summary: "Step-by-step workflow for AI agents to update documentation safely using the ALWAYS LINK policy and .agent tooling."
type: "how-to"
scope: "repo"
tags:
  - "agent"
  - "documentation"
  - "workflow"
related:
  - "../INDEX.md"
  - "../policies/INDEX.md"
  - "../commands/INDEX.md"
  - "../policies/always-link.md"
  - "../../contributing.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-20"
canonical_url: "docs/agent/workflows/update-docs.md"
---

# Agent Workflow: Updating Documentation

This document defines the recommended end-to-end workflow for AI agents that update documentation in this repository. It complements the high-level rules in [`docs/agent/policies/general-instructions.md`](../policies/general-instructions.md:1) and the ALWAYS LINK policy in [`docs/agent/policies/always-link.md`](../policies/always-link.md:1).

Use this workflow whenever you add, restructure, or significantly edit files under `docs/`, `README.md`, or `AGENTS.md`.

## 1. Read constraints and goals

Before changing any docs:

- Read the project overview: [`README.md`](../../README.md:1).
- Read the agent guide: [`AGENTS.md`](../../AGENTS.md:1).
- Review agent policies: [`docs/agent/policies/INDEX.md`](../policies/INDEX.md:1).
- Review the documentation contributing guide: [`docs/contributing.md`](../../contributing.md:1).

Confirm that the requested change fits the repository’s goals and the ALWAYS LINK model (one canonical doc per concept, link stubs elsewhere).

## 2. Run inventory and classification

Use the `.agent` tooling to understand the current documentation set:

- Inventory: run `python3 .agent/doc_inventory.py`.
- Classification: run `python3 .agent/doc_classify.py`.

These commands extract documentation units and classify them by subject, type, and canonical doc. Detailed command descriptions live in [`docs/agent/commands/INDEX.md`](../commands/INDEX.md:1).

## 3. Design canonical changes

Using the inventory and classification outputs:

- Identify which concepts already have canonical docs under `docs/`.
- Decide whether your change:
  - Updates an existing canonical doc, or
  - Creates a new canonical doc under `docs/<subject>/<slug>.md`, or
  - Converts legacy text into a short link stub pointing to an existing canonical doc.
- Ensure there will be **exactly one** canonical doc per concept, per [`ALWAYS LINK`](../policies/always-link.md:1).

Record any migration decisions in the doc body as short “Source” notes when you promote text out of legacy locations.

## 4. Edit documentation

When editing or creating docs:

- Follow the front matter schema from [`docs/contributing.md`](../../contributing.md:1), including `canonical_url` for canonical docs.
- Keep documents bite-sized (typically 200–600 words) and focused on a single concept.
- Avoid duplicating explanations; prefer to:
  - Move shared explanations into a canonical doc under `docs/`, then
  - Replace old copies with 1–2 sentence link stubs.
- When touching agent-specific guidance, prefer adding or updating docs under `docs/agent/` (policies, workflows, commands) and linking from `AGENTS.md`.

## 5. Run the link audit

After your edits:

- Run `python3 .agent/doc_audit.py`.
- Inspect `.agent/tmp/audit.json` for:
  - Broken links or incorrect relative paths.
  - Oversize documents that should be split.
  - Multiple canonical docs claiming the same concept.

Use the findings to refine your changes until the audit output is clean or clearly understood.

## 6. Log the run and finalize

Before considering the task complete:

- Create or update a log entry under `.agent/log/` following:
  - Working-directory and logging policy: [`docs/agent/policies/agent-working-directory-and-logging.md`](../policies/agent-working-directory-and-logging.md:1).
  - Log naming and content rules under [`docs/policies/log-file-naming-and-location.md`](../../policies/log-file-naming-and-location.md:1) and [`docs/policies/log-content-guidelines.md`](../../policies/log-content-guidelines.md:1).
- Ensure diffs are focused and minimal, and that rerunning this workflow would not create duplicate docs or break links.

Once these steps are complete, the documentation update is considered consistent with the repository’s agent and documentation policies.