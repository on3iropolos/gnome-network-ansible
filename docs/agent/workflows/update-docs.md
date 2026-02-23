---
title: "Agent Workflow: Updating Documentation"
summary: "Step-by-step workflow for AI agents to update documentation safely using the Always Link policy and .agent tooling."
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

This workflow is the **minimal checklist** for updating docs as an agent. It assumes you follow the general rules in [`../policies/general-instructions.md`](../policies/general-instructions.md:1) and the Always Link policy in [`../policies/always-link.md`](../policies/always-link.md:1).

Use it whenever you add, restructure, or significantly edit files under `docs/`, `README.md`, or `AGENTS.md`.

## 1. Read constraints and goals

- Project overview: [`README.md`](../../../README.md:1)
- Agent guide: [`AGENTS.md`](../../../AGENTS.md:1)
- Agent docs index: [`docs/agent/INDEX.md`](../INDEX.md:1)
- Contributing and policies:
  - [`docs/contributing.md`](../../contributing.md:1)
  - [`docs/policies/INDEX.md`](../../policies/INDEX.md:1)
  - [`docs/agent/policies/always-link.md`](../policies/always-link.md:1)

Confirm that the requested change fits the Always Link model (one canonical doc per concept, link stubs elsewhere).

## 2. Inventory and classification (when concepts or layout change)

If you are changing concepts, layout, or canonical targets:

- Run inventory: `python3 .agent/doc_inventory.py`
- Run classification: `python3 .agent/doc_classify.py`
- See command reference: [`docs/agent/commands/INDEX.md`](../commands/INDEX.md:1)

Use these outputs to understand existing canonical docs, duplicates, and subjects before editing.

## 3. Plan canonical changes

For each concept you touch, decide whether you will:

- Update an existing canonical doc under `docs/<subject>/<slug>.md`, or
- Create a new canonical doc under `docs/<subject>/<slug>.md`, or
- Replace legacy text with a short link stub pointing at an existing canonical doc.

Ensure there is **exactly one** canonical doc per concept, per [`always-link`](../policies/always-link.md:1).

## 4. Edit docs

While editing or creating docs:

- Follow the front matter schema and subject layout in [`docs/contributing.md`](../../contributing.md:1).
- Keep docs bite-sized (usually 200–600 words).
- Move shared explanations into canonical docs and leave behind 1–2 sentence link stubs.
- Prefer links (including section anchors) over copying content between files.

## 5. Run the link audit

After your edits:

- Run `python3 .agent/doc_audit.py`.
- Inspect `.agent/tmp/audit.json` for:
  - Broken or incorrect links.
  - Oversize docs that should be split.
  - Multiple canonical docs claiming the same concept.

Refine your changes until the audit output is clean or you clearly understand and accept any remaining findings.

## 6. Log the run

Before considering the task complete:

- Write or update a log entry under `.agent/log/` following:
  - [`../policies/agent-operational-policies.md`](../policies/agent-operational-policies.md:1)
  - The logging policies under [`docs/policies/INDEX.md`](../../policies/INDEX.md:1)

Keep diffs as small as practical and ensure that re-running this workflow would not create duplicate docs or inconsistent links.