---
title: "Agent Documentation Index"
summary: "Index of canonical documentation and tooling for AI agents working in this repository."
type: "reference"
scope: "repo"
tags:
  - "agent"
  - "documentation"
  - "policy"
related:
  - "policies/INDEX.md"
  - "workflows/update-docs.md"
  - "commands/INDEX.md"
  - "../policies/INDEX.md"
  - "../contributing.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-20"
canonical_url: "docs/agent/INDEX.md"
---

# Agent Documentation Index

This index collects the canonical documentation that AI agents should use when operating on this repository. It complements the high-level agent guide in [`AGENTS.md`](../../AGENTS.md:1).

Use this page as the main entrypoint when you need to discover or extend **agent-specific** documentation under `docs/agent/`.

## Agent policy docs

Agent-focused policies live under `docs/agent/policies/` and are indexed at:

- **Agent policies index**  
  Overview of agent-facing policy stubs and where their canonical definitions live.  
  See [`docs/agent/policies/INDEX.md`](policies/INDEX.md:1).

Key policies for agents:

- **Always Link documentation policy**  
  Canonical definition of the documentation model: one canonical doc per concept, bite-sized files, and link stubs everywhere else.  
  See [`docs/agent/policies/always-link.md`](policies/always-link.md:1).

- **General instructions for AI agents**
  High-level expectations for agents: understand the project first, respect canonical docs, prefer scripted/idempotent changes, and honor testing policies.
  See [`docs/agent/policies/general-instructions.md`](policies/general-instructions.md:1).

- **Agent workspace policy**
  Requirements for using `.agent/` as a working area and for managing transient artifacts under `.agent/`.
  See [`agent-workspace.md`](policies/agent-workspace.md:1).

- **Agent logging policy**
  Requirements for writing concise, structured logs under `.agent/log/` so humans can reconstruct automated activity.
  See [`agent-logging.md`](policies/agent-logging.md:1).

For the full set of repository-wide policies (not just agent-focused ones), see the main policies index at  
[`docs/policies/INDEX.md`](../policies/INDEX.md:1).

## Agent workflows

Task-oriented workflows for agents live under `docs/agent/workflows/`.

- **Updating documentation**  
  End-to-end workflow for updating docs safely using the Always Link policy and tooling (inventory, classify, audit).  
  See [`docs/agent/workflows/update-docs.md`](workflows/update-docs.md:1).

Additional workflows can be added to this directory as the automation surface grows.

## Agent commands and tooling

Command references for agent scripts live under `docs/agent/commands/`.

- **Agent commands index**  
  Documents the primary scripts such as `doc_inventory.py`, `doc_classify.py`, and `doc_audit.py`, including typical usage and outputs.  
  See [`docs/agent/commands/INDEX.md`](commands/INDEX.md:1).

## Issue tracking with bd (beads)

This project uses **bd (beads)** for all issue tracking and task management.

- **Beads documentation**: https://gastownhall.github.io/beads/
- **Quick start**: `bd ready --json` to find ready work
- **Workflow**: See AGENTS.md for complete beads workflow

Remember that `.agent/` is for ephemeral working files only. Canonical explanations and policies always live under `docs/`.