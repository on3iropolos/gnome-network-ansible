---
title: "Documenting roles and repository"
summary: "Defines documentation expectations for Ansible roles, repository structure updates, and in-code clarity, integrating with the Always Link documentation system."
type: "how-to"
scope: "repo"
tags:
  - "documentation"
  - "ansible"
  - "roles"
  - "agent"
related:
  - "../contributing.md"
  - "../agent/policies/always-link.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-19"
canonical_url: "docs/how-to/documenting-roles-and-repository.md"
source: "docs/policies/documentation.md"
---

# Documentation guidance

> Source: This guide was migrated from the former "Documentation Policy" that previously lived under `docs/policies/documentation.md`.

This guide explains how to document Ansible roles, repository structure, and non-obvious code in this repository. It builds on the Always Link system (see Beads issue `gnome-network-ansible-3s`) and the contributing guide in [`docs/contributing.md`](../contributing.md:1).

## Scope and relationship to Always Link

- Use this document for **what must be documented** in roles and top-level files.
- See Beads issue `gnome-network-ansible-3s` for **how docs are organized** (canonical docs, link stubs, front matter).
- Use [`docs/contributing.md`](../contributing.md:1) for **how to add or update docs** within the `docs/` tree.

All new documentation work should:

- Prefer creating or updating canonical docs under `docs/` instead of putting long explanations into READMEs or comments.
- Replace any large in-place explanations in `README.md`, role READMEs, or `.agent` files with short link stubs that point at the appropriate canonical doc.

## Role README requirements

When you create a new Ansible role, you **must** add a `README.md` in that role’s directory and base it on the shared template:

- Role README template: [`roles/role_template/README.md`](../../roles/role_template/README.md:1)

At minimum, fill in:

- **Role Name** – clear, human-readable name matching the directory.
- **Description** – what the role configures or manages and on which platforms.
- **Role Variables** – important variables and their defaults (link to `defaults/main.yml` when appropriate).
- **Dependencies** – other roles or external systems required by this role.
- **Example Playbook** – a minimal, working playbook snippet that uses the role.

Additional notes:

- Keep the README concise and defer deep explanations to canonical docs under `docs/roles/` (for example, a dedicated role how-to).
- When you promote content from a role README into `docs/`, leave behind a 1–2 sentence link stub that points to the canonical doc, following the Always Link policy.

## Repository structure documentation

Changes to the top-level repository layout **must** be reflected in the human entrypoint [`README.md`](../../README.md:1):

- When adding a new role, top-level directory, or major workflow, update the “Repository Structure” and any relevant overview sections.
- Instead of embedding long explanations, add or update canonical docs under `docs/` and link to them from `README.md` using short, task-oriented stubs.
- Maintain diagrams (for example Mermaid graphs) in canonical docs; `README.md` should link to them rather than duplicate them.

This ensures that humans get an accurate high-level map from `README.md` while details remain in small, reusable docs under `docs/`.

## Clarity in playbooks and code

Good documentation also lives close to the code:

- Give every Ansible task a descriptive `name` so that playbook output is self-explanatory.
- Add short comments near complex logic, non-obvious workarounds, or important invariants.
- Prefer linking to canonical docs for background and rationale instead of writing long prose comments.

When a comment or inline explanation grows beyond a few lines, promote it into an appropriate canonical doc (for example under `docs/roles/`, `docs/ansible/`, or `docs/policies/`) and leave a short comment that links back to that doc.