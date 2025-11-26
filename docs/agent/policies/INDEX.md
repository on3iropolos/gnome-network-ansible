---
title: "Agent Policies Index"
summary: "Index of agent-focused policy entrypoints under docs/agent/policies/, each pointing to canonical repository policies."
type: "reference"
scope: "repo"
tags:
  - "agent"
  - "policy"
  - "documentation"
related:
  - "../../policies/INDEX.md"
  - "always-link.md"
  - "general-instructions.md"
  - "agent-workspace.md"
  - "agent-logging.md"
  - "working-directory.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-20"
canonical_url: "docs/agent/policies/INDEX.md"
---

# Agent Policies Index

This index lists agent-focused policy documents. Each document under `docs/agent/policies/` is a canonical agent-facing policy or reference. The overall documentation model is defined in [`docs/agent/policies/always-link.md`](always-link.md:1).

Use this page when you need to discover which high-level policies agents must follow and where their canonical definitions live.

## Core agent policies

- **Always Link documentation policy**
  Canonical definition of the documentation model: one canonical doc per concept, bite-sized files, and link stubs everywhere else.
  See `docs/agent/policies/always-link.md`.

- **General instructions for AI agents**
  High-level expectations for agents: understand the project first, respect canonical docs, prefer scripted/idempotent changes, and honor testing and logging policies.
  See `docs/agent/policies/general-instructions.md`.

- **Agent workspace (.agent/)**
  Requirements for using `.agent/` as a working area for transient artifacts, helper scripts, and other agent tooling.
  See `docs/agent/policies/agent-workspace.md`.

- **Agent logging**
  Requirements for writing concise, structured logs under `.agent/log/` so humans can reconstruct what was done and why.
  See `docs/agent/policies/agent-logging.md` together with the logging policies under `docs/policies/`.

## Relationship to main policy index

For a complete view of all repository policies (not just agent-focused ones), start from the main policies index at [`docs/policies/INDEX.md`](../../policies/INDEX.md:1). That document remains the canonical overview of policy documents; this file simply collects the most important ones for agent workflows.