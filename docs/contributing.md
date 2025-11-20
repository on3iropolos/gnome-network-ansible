---
title: "Contributing Documentation to Gnome Network Ansible"
summary: "Explains how to add and maintain documentation using the ALWAYS LINK policy, canonical docs, and the docs/ subject-based structure."
type: "how-to"
scope: "repo"
tags:
  - "documentation"
  - "policy"
  - "always-link"
  - "contributing"
related:
  - "agent/policies/always-link.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-19"
canonical_url: "docs/contributing.md"
---

This document describes how to write and evolve documentation in this repository while following the ALWAYS LINK policy and the subject-based layout under `docs/`.

## When to add or change docs

Add or update docs when you:

- Introduce or remove a feature, role, or Terraform module.
- Change behavior that affects existing users or operators.
- Add new troubleshooting steps or runbooks.
- Adjust internal processes for agents (inventory, classification, link audit, etc.).

Before writing anything new, **search for an existing canonical doc** that covers the concept. If one exists, update it or add a link stub instead of creating a second full explanation.

See the ALWAYS LINK policy for details: [ALWAYS LINK policy](agent/policies/always-link.md).

## File placement and naming

All canonical docs live under `docs/<subject>/<slug>.md`:

- **Subject**: One of `policies, architecture, roles, inventories, networking, terraform, ansible, testing, operations, security, decisions, troubleshooting, workflows, conventions, reference, how-to`.
- **Slug**: Short, lowercase, kebab-case; no dates in the filename (dates belong in front matter).

Examples:

- `docs/terraform/testing-with-terraform-libvirt.md`
- `docs/roles/network-role-overview.md`
- `docs/troubleshooting/molecule-common-failures.md`

If you are unsure which subject to use, pick the one that best matches the dominant topic (for example, Terraform usage belongs under `terraform` even if it mentions roles).

## Required front matter

Every authored doc must start with YAML front matter using this schema:

- `title`: Human-readable title.
- `summary`: 1–3 sentences summarizing the doc; should match the first paragraph.
- `type`: One of `concept, tutorial, how-to, reference, policy, runbook, decision, changelog, faq, api`.
- `scope`: One of `repo, role, environment, infra, ops, dev, sec, qa`.
- `tags`: Short list of topic tags (for example, `ansible`, `terraform`, `network`, `testing`).
- `related`: Relative paths to closely related docs under `docs/`.
- `owner`: Team or person responsible for the content.
- `last_reviewed`: Date as `YYYY-MM-DD`.
- `canonical_url`: Relative path to this file (for example, `docs/testing/molecule-testing.md`).

Canonical docs **must** set `canonical_url`. Link stubs **must not** reuse the same `canonical_url` as their target.

## Canonical docs vs. link stubs

Follow these rules when editing existing files:

- If the file already holds the richest explanation for a concept, keep it as canonical and ensure its front matter is complete.
- If the same concept appears in multiple places, choose a single canonical file and convert all others into short link stubs.
- A link stub is typically 1–2 sentences plus a link, for example:
  `For the full Terraform VM testing workflow, see [Terraform VM testing](../terraform/testing-with-terraform-libvirt.md).`

README files and in-file comments may still contain local context (for example, how a role uses a canonical workflow) but must delegate the detailed explanation to canonical docs under `docs/`.

## Bite-sized docs

Aim for **200–600 words** per canonical doc:

- Split large topics into multiple related docs (for example, an overview plus focused how-tos).
- Use the `related` field and inline links to connect sibling docs.
- Prefer linking to section anchors inside a canonical doc rather than copying sections into new files.

When a doc grows beyond ~800 words, consider extracting subsections into their own canonical docs and leaving behind summary-level text and links.

## Keeping the system idempotent

When you modify docs:

- Update `last_reviewed` in the front matter.
- Keep canonical URLs stable; do not rename or move canonical files without updating all links and the classification data.
- Do not write long-form documentation directly into `README.md`, `AGENTS.md`, or code comments when it belongs in `docs/`; add a link stub instead.

If you add a new canonical doc, ensure that any overlapping existing content is converted to link stubs in the same change so the ALWAYS LINK policy remains enforced.