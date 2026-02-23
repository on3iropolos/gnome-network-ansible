---
name: canonical-docs
description: Defines the Always Link policy: every concept has exactly one canonical document, and all other mentions must link to that source instead of duplicating content.
license: MIT
compatibility: opencode
metadata:
  policy: documentation
  repo: gnome-network-ansible
---

# Always Link Documentation Policy

The Always Link policy defines how documentation is organized and maintained. Every concept has exactly one canonical document; all other mentions must link to that document instead of duplicating its content.

## Goals

- Eliminate drift and contradictions between duplicated docs
- Keep documents small, focused, and easy to navigate
- Make the documentation system safe for automation and repeated agent runs

## Core Rules

### 1. Exactly one canonical doc per concept

- A "concept" is a coherent topic (e.g., "Molecule testing" or "network role tests")
- The canonical doc lives under `docs/<subject>/<slug>.md` and includes the `canonical_url` field in its front matter

### 2. Never duplicate content

- Do not copy paragraphs, examples, or explanations between files
- If you need the same information in multiple places, extract it into a canonical doc and link to it

### 3. Use link stubs for secondary mentions

A link stub is a short 1-2 sentence pointer that links to a canonical doc or section anchor.

Example:
```
For the full Molecule testing workflow, see [Molecule testing](../../reference/testing-best-practices.md).
```

### 4. Preserve sources non-destructively

When promoting content into a canonical doc, record the original location in the doc body or in a "Source" note. Existing files that contained the original explanation become link stubs pointing to the canonical doc.

## Front Matter Requirements

All canonical docs must include the following front matter fields:

- `title`: Human-readable title
- `summary`: 1-3 sentence summary of the doc
- `type`: One of `concept`, `tutorial`, `how-to`, `reference`, `policy`, `runbook`, `decision`, `changelog`, `faq`, `api`
- `scope`: One of `repo`, `role`, `environment`, `infra`, `ops`, `dev`, `sec`, `qa`
- `tags`: A short list of topic tags
- `related`: Relative links to closely related docs
- `owner`: Team or person accountable for the content
- `last_reviewed`: Date of the last human review in `YYYY-MM-DD` format
- `canonical_url`: Relative path to this file (`docs/...`)

Non-canonical link-stub files may have minimal front matter, but must **not** use the same `canonical_url` as any canonical doc.

## Bite-Sized Documents

- Aim for **200-600 words** per canonical doc when possible
- Split large topics into multiple docs connected with `related` links
- Very small reference entries may be shorter if part of a structured reference set

## Idempotent Agent Behavior

Agents working in this repository **must**:

- Treat `docs/classified.yaml` as the current inventory of documentation units and signatures
- Preserve existing canonical docs whenever possible, updating them in place rather than creating new copies
- Convert overlapping content into link stubs instead of duplicating text
- Avoid editing `.agent/tmp/` materials as if they were canonical

Re-running inventory, classification, authoring, or link-audit scripts must not introduce new duplicate docs or diverging versions of the same concept.

## Related skills

- [update-docs](update-docs): Complete documentation update workflow
- [doc-inventory](doc-inventory): Scan and inventory docs
- [doc-classify](doc-classify): Classify docs and detect duplicates
- [doc-audit](doc-audit): Audit docs for broken links and issues
- [agent-instructions](agent-instructions): General agent rules
