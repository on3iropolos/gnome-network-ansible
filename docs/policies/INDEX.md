---
title: "Policies Documentation Index"
summary: "Index of canonical policy documents for the Gnome Network Ansible repository, including Always Link, general agent instructions, and documentation contribution rules."
type: "reference"
scope: "repo"
tags:
  - "policy"
  - "documentation"
  - "agent"
related:
  - "always-link.md"
  - "general-instructions.md"
  - "../contributing.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-19"
canonical_url: "docs/policies/INDEX.md"
---

# Policies Documentation Index

This index lists canonical policy documents under `docs/policies/` and related top-level documentation that govern how this repository is maintained.

Use this page as the starting point when you need to understand or update repository-wide rules.

## Core policies

- **Always Link policy**
  Canonical definition of the documentation model: one canonical doc per concept, bite-sized files, and link stubs everywhere else.
  See Beads issue: `gnome-network-ansible-3s` (run `bd list --json` to view).

- **General instructions for AI agents**
  High-level expectations for agents: understand the project first, respect canonical docs, prefer scripted/idempotent changes, and honor testing policies.
  See Beads issue: `gnome-network-ansible-3t` (run `bd list --json` to view).

- **Documentation contributing guide**  
  How to write new docs that comply with the Always Link system, including required front matter, subjects, and slug rules.  
  See [`../contributing.md`](../contributing.md:1).

## How to use these policies

- When adding or changing documentation, start from the contributing guide and Always Link policy.
- When implementing automated agents or scripts, ensure they follow the general instructions and treat these policy docs as canonical sources.
- If a new policy is needed, add a bite-sized canonical doc under `docs/policies/` and link to it from here instead of embedding long text into `README.md` or `AGENTS.md`.