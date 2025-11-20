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

- **ALWAYS LINK documentation policy**  
  Canonical definition of the documentation model: one canonical doc per concept, bite-sized files, and link stubs everywhere else.  
  See [`docs/agent/policies/always-link.md`](policies/always-link.md:1).

- **General instructions for AI agents**  
  High-level expectations for agents: understand the project first, respect canonical docs, prefer scripted/idempotent changes, and honor testing policies.  
  See [`docs/agent/policies/general-instructions.md`](policies/general-instructions.md:1).

- **Agent working directory and logging**  
  Requirements for using `.agent/` as a working area and for writing audit logs under `.agent/log/`.  
  See [`docs/agent/policies/agent-working-directory-and-logging.md`](policies/agent-working-directory-and-logging.md:1).

For the full set of repository-wide policies (not just agent-focused ones), see the main policies index at  
[`docs/policies/INDEX.md`](../policies/INDEX.md:1).

## Agent workflows

Task-oriented workflows for agents live under `docs/agent/workflows/`.

- **Updating documentation**  
  End-to-end workflow for updating docs safely using the ALWAYS LINK policy and `.agent` tooling (inventory, classify, audit).  
  See [`docs/agent/workflows/update-docs.md`](workflows/update-docs.md:1).

Additional workflows can be added to this directory as the automation surface grows.

## Agent commands and tooling

Command references for `.agent/` scripts live under `docs/agent/commands/`.

- **Agent commands index**  
  Documents the primary `.agent` scripts such as `doc_inventory.py`, `doc_classify.py`, and `doc_audit.py`, including typical usage and outputs.  
  See [`docs/agent/commands/INDEX.md`](commands/INDEX.md:1).

Remember that the scripts themselves live under `.agent/` and their outputs under `.agent/tmp/` are **ephemeral**. Canonical explanations and policies always live under `docs/`.