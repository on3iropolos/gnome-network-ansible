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
last_reviewed: "2025-11-19"
canonical_url: "docs/agent/policies/general-instructions.md"
---

> Source: This document was migrated from [`docs/policies/general-instructions.md`](../../policies/general-instructions.md:1) to be part of the agent documentation collection under `docs/agent/`.

This document summarizes the core expectations for AI agents working in this repository. It complements the more detailed per-topic instructions in `.agent/instructions/` and the project overview in [`README.md`](../../README.md:1).

The original source for these instructions is [`general_instructions.md`](.agent/instructions/general_instructions.md:1); this file is the canonical high-level policy for agents.

## 1. Understand the project first

Before making changes:

- Read the project overview and goals in [`README.md`](../../README.md:1).
- Read this agent guide in [`AGENTS.md`](../../AGENTS.md:1).
- Review the Always Link policy in [`always-link.md`](always-link.md:1).
- Review the documentation contributor guide in [`contributing.md`](../../contributing.md:1).

Your edits must align with the repository’s goals and documentation system, not just the immediate user request.

## 2. Follow canonical documentation rules

When working with docs:

- Treat `docs/` as the **canonical** home for concepts, as required by the Always Link policy in [`always-link.md`](always-link.md:1).
- Avoid duplicating explanations in `README.md`, role `README.md` files, or code comments; link to the appropriate doc under `docs/` instead.
- When promoting existing text (for example from `.agent/instructions/` or a role README) into `docs/`, keep a short “Source” note or link stub at the original location.

For how to structure new docs, front matter fields, and subjects/slugs, follow [`docs/contributing.md`](../../contributing.md:1).

## 3. Prefer scripted, idempotent changes

When changing code or docs:

- Use repository tooling where available (for example [`doc_inventory.py`](../../.agent/doc_inventory.py:1), [`doc_classify.py`](../../.agent/doc_classify.py:1)) instead of ad‑hoc edits when those tools own a file.
- Make changes idempotent: re-running the same steps should not corrupt docs, create duplicates, or break links.
- Keep commits and diffs small and focused on a single logical change when possible.

## 4. Respect testing and linting expectations

Agents must not ignore testing requirements:

- Follow the testing and linting policies summarized in the instructions sourced from [`testing_and_linting.md`](.agent/instructions/testing_and_linting.md:1).
- When changes may affect Ansible roles, Molecule scenarios, or Terraform, ensure that the relevant commands (for example `ansible-lint`, `molecule test`, or Terraform plans) are considered and referenced in your plan.

## 5. Precedence and safety

When instructions conflict:

1. The user’s direct instructions for the current task take precedence, as long as they do not obviously damage the repository.
2. Repository policies (including this file and the Always Link policy) guide how you implement the user’s request.
3. Per-topic instructions in `.agent/instructions/` refine the details (working directory, logging, testing, interaction, diagrams).

If you must deviate from these policies to satisfy a user request, keep the deviation as local as possible and avoid breaking canonical docs or automated tooling.

## 6. Where to read more

For more detailed guidance:

- Always Link policy: [`always-link.md`](always-link.md:1)
- Documentation system and examples: [`contributing.md`](../../contributing.md:1)
- Agent working directory and logging: [`agent-working-directory-and-logging.md`](agent-working-directory-and-logging.md:1)
- Agent working directory and logging (legacy source): [`working_directory.md`](.agent/instructions/working_directory.md:1)
- Testing and linting specifics: [`testing_and_linting.md`](.agent/instructions/testing_and_linting.md:1)
- Interaction rules: [`interaction.md`](.agent/instructions/interaction.md:1)
- Mermaid diagrams: [`mermaid_diagram_guidelines.md`](.agent/instructions/mermaid_diagram_guidelines.md:1)