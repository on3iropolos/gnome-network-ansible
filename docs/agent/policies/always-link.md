---
title: "ALWAYS LINK Documentation Policy"
summary: "Defines the ALWAYS LINK policy for this repository: every concept has exactly one canonical document, and all other mentions must link to that source instead of duplicating content."
type: "policy"
scope: "repo"
tags:
  - "documentation"
  - "policy"
  - "always-link"
  - "agent"
related:
  - "../../contributing.md"
  - "../INDEX.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-19"
canonical_url: "docs/agent/policies/always-link.md"
---

> Source: This policy was migrated from [`docs/policies/always-link.md`](../../policies/always-link.md:1) to make it part of the agent documentation collection under `docs/agent/`.

The ALWAYS LINK policy defines how documentation is organized and maintained in this repository. Every concept has exactly one canonical document; all other mentions must link to that document instead of duplicating its content.

## Goals

- Eliminate drift and contradictions between duplicated docs.
- Keep documents small, focused, and easy to navigate.
- Make the documentation system safe for automation and repeated agent runs.

## Core Rules

1. **Exactly one canonical doc per concept**  
   - A "concept" is a coherent topic (for example "Terraform VM testing" or "network role Molecule tests").  
   - The canonical doc lives under `docs/<subject>/<slug>.md` and includes the `canonical_url` field in its front matter.

2. **Never duplicate content**  
   - Do not copy paragraphs, examples, or explanations between files.  
   - If you need the same information in multiple places, extract it into a canonical doc and link to it.

3. **Use link stubs for secondary mentions**  
   - A link stub is a short 1–2 sentence pointer that links to a canonical doc or section anchor.  
   - Example:  
     `For the full Terraform VM testing workflow, see [Terraform VM testing](../../terraform/testing-with-terraform-libvirt.md).`

4. **Preserve sources non-destructively**  
   - When promoting content into a canonical doc, record the original location in the doc body or in a "Source" note.  
   - Existing files that contained the original explanation become link stubs pointing to the canonical doc.

## Front Matter Requirements

All canonical docs must include the following front matter fields:

- `title`: Human-readable title.
- `summary`: 1–3 sentence summary of the doc. Should match the first paragraph in the body.
- `type`: One of `concept`, `tutorial`, `how-to`, `reference`, `policy`, `runbook`, `decision`, `changelog`, `faq`, `api`.
- `scope`: One of `repo`, `role`, `environment`, `infra`, `ops`, `dev`, `sec`, `qa`.
- `tags`: A short list of topic tags, such as `ansible`, `terraform`, `network`, `testing`, `agent`.
- `related`: Relative links to closely related docs.
- `owner`: Team or person accountable for the content.
- `last_reviewed`: Date of the last human review in `YYYY-MM-DD` format.
- `canonical_url`: Relative path to this file (`docs/...`).

Non-canonical link-stub files may have minimal front matter, but they must **not** use the same `canonical_url` as any canonical doc.

## Canonical vs. Non-Canonical Examples

### Canonical example

A canonical Terraform VM testing doc could live at:

- `docs/terraform/testing-with-terraform-libvirt.md`

Its front matter would include:

```yaml
canonical_url: "docs/terraform/testing-with-terraform-libvirt.md"
type: "how-to"
scope: "infra"
```

Any other file that previously described the full workflow should be replaced with a short pointer:

```markdown
This document has been canonicalized. See  
[Terraform VM testing](../../terraform/testing-with-terraform-libvirt.md) for the up-to-date workflow.
```

### Link stub example

A role README section that used to describe Terraform VM testing can become:

```markdown
For VM-based testing of this role, follow  
[Terraform VM testing](../../../docs/terraform/testing-with-terraform-libvirt.md).
```

The README keeps local context (for example, which role the instructions apply to) but delegates the procedure to the canonical doc.

## Bite-Sized Documents

- Aim for **200–600 words** per canonical doc when possible.  
- Split large topics into multiple docs connected with `related` links (for example, `testing-overview`, `molecule-testing`, `terraform-vm-testing`).  
- Very small reference entries (for example, a single config option) may be shorter if they are part of a structured reference set.

## Idempotent Agent Behavior

Agents working in this repository **must**:

- Treat `docs/classified.yaml` as the current inventory of documentation units and signatures.
- Preserve existing canonical docs whenever possible, updating them in place rather than creating new copies.
- Convert overlapping content into link stubs instead of duplicating text.
- Avoid editing `.agent/tmp/` materials as if they were canonical; instead, promote stable concepts into proper docs under `docs/`.

Re-running inventory, classification, authoring, or link-audit scripts must not introduce new duplicate docs or diverging versions of the same concept.