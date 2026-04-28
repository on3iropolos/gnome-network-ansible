---
title: "Documentation index"
summary: "Index of canonical documentation about how to structure, write, and maintain docs for roles, repository layout, and inline code comments."
type: "reference"
scope: "repo"
tags:
  - "documentation"
  - "ansible"
  - "roles"
  - "agent"
related:
  - "../contributing.md"
  - "../how-to/documenting-roles-and-repository.md"
  - "always-link.md"
  - "../architecture/mermaid-diagram-guidelines.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-20"
canonical_url: "docs/policies/documentation.md"
source: ".agent/instructions/documentation.md"
---

# Documentation index

This file is an index for documentation-related guidance. It replaces the former “Documentation Policy” with a set of smaller, focused docs under `docs/`.

Use the docs linked here as the canonical references for **what** must be documented and **how** those docs are structured.

## Core documentation model

- [`Always Link documentation policy`](always-link.md:1)  
  Canonical definition of the documentation model:
  - Exactly one canonical doc per concept.
  - Bite-sized documents with clear front matter.
  - Link stubs instead of duplicated text.

- [`Contributing documentation to Gnome Network Ansible`](../contributing.md:1)  
  How to:
  - Place files under the correct `docs/<subject>/` folder.
  - Use the required front matter schema.
  - Decide when to create a new canonical doc vs. a link stub.

## What to document for roles and repository

- [`Documenting roles and repository`](../how-to/documenting-roles-and-repository.md:1)  
  How-to guide describing:
  - Required content for role `README.md` files (variables, examples, dependencies).
  - When and how to promote content from role READMEs into canonical docs under `docs/`.
  - Expectations for documenting top-level repository structure and new directories in [`README.md`](../../README.md:1).

## Diagrams and visual documentation

- [`Mermaid diagram guidelines`](../architecture/mermaid-diagram-guidelines.md:1)  
  When and how to use Mermaid diagrams:
  - Appropriate use cases for diagrams vs. plain text.
  - Style and maintenance guidelines.
  - Example contribution workflow that ties diagrams to documentation updates.

## Using this index

When you add or update documentation:

1. Start from the Always Link policy and contributing guide to understand structure and front matter.
2. Use the “Documenting roles and repository” how-to for role READMEs and repository-wide docs.
3. Use the Mermaid guidelines whenever you add or modify diagrams.
4. Prefer adding or updating canonical docs under `docs/` and leaving short link stubs in READMEs or comments, rather than duplicating explanations.