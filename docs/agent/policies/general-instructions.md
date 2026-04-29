---
title: "General Instructions for AI Agents"
summary: "High-level rules for AI agents working in this repository, including how to respect canonical documentation, follow project goals, and keep changes safe and idempotent."
type: "policy"
scope: "repo"
tags:
  - "agent"
  - "documentation"
  - "policy"
related:
  - "always-link.md"
  - "../../contributing.md"
  - "../../README.md"
  - "../../AGENTS.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2026-02-23"
canonical_url: "docs/agent/policies/general-instructions.md"
---

This document summarizes the core expectations for AI agents working in this repository.

## 1. Understand the project first

Before making changes:

- Read the project overview in [`README.md`](../../../README.md:1).
- Read the agent guide in [`AGENTS.md`](../../../AGENTS.md:1).
- Review the Always Link policy in [`always-link.md`](always-link.md:1).
- Review the documentation contributor guide in [`contributing.md`](../../contributing.md:1).

## 2. Follow canonical documentation rules

When working with docs:

- Treat `docs/` as the **canonical** home for concepts.
- Avoid duplicating explanations; link to docs instead.
- Keep commits small and focused.

See [`always-link.md`](always-link.md:1) and [`contributing.md`](../../contributing.md:1) for details.

## 3. Prefer scripted, idempotent changes

- Use repository tooling and Hindsight memory instead of ad-hoc edits.
- Re-running should not corrupt docs or create duplicates.
- Keep diffs focused on single logical changes.

## 4. Respect testing and linting

- Run `ansible-lint` before pushing.
- Test roles with Molecule before submitting changes.
- See [`testing-best-practices.md`](../../reference/testing-best-practices.md:1).

## 5. Precedence

When instructions conflict:

1. User's direct instructions take precedence (if they don't damage the repo).
2. Repository policies guide implementation.
3. Keep deviations local and reversible.

## 6. Where to read more

- Always Link policy: [`always-link.md`](always-link.md:1)
- Documentation system: [`contributing.md`](../../contributing.md:1)
- Agent operational policies: [`agent-operational-policies.md`](agent-operational-policies.md:1)
- Testing best practices: [`testing-best-practices.md`](../../reference/testing-best-practices.md:1)
