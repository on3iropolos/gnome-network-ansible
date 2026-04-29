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
  Overview of agent-facing policies and where their canonical definitions live.  
  See [`docs/agent/policies/INDEX.md`](policies/INDEX.md:1).

Key policies for agents:

- **Always Link documentation policy**  
  Canonical definition of the documentation model: one canonical doc per concept, bite-sized files, and link stubs everywhere else.  
  See [`docs/agent/policies/always-link.md`](policies/always-link.md:1).

- **General instructions for AI agents**
  High-level expectations for agents: understand the project first, respect canonical docs, prefer scripted/idempotent changes, and honor testing policies.
  See [`docs/agent/policies/general-instructions.md`](policies/general-instructions.md:1).

- **Agent operational policies**  
  Combined workspace and logging rules for AI agents using the `.agent/` area.
  See [`agent-operational-policies.md`](policies/agent-operational-policies.md:1).

For the full set of repository-wide policies (not just agent-focused ones), see the main policies index at  
[`docs/policies/INDEX.md`](../policies/INDEX.md:1).

## Agent commands and tooling

- **Agent operational policies**  
  See [`docs/agent/policies/agent-operational-policies.md`](policies/agent-operational-policies.md:1) for workspace and logging policies.