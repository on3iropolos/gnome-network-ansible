# Documentation Structure Plan

This file is an internal agent planning note and is not part of the canonical documentation set.

## Canonical doc mapping

- Source of truth for units and duplicates is `docs/classified.yaml`.
- Each unit with `canonical: true` will produce one canonical Markdown file at its `canonical_doc` path.
- Each canonical doc path follows `docs/<subject>/<slug>.md` with `subject` in the approved taxonomy.
- Units with `canonical: false` will not get their own canonical files; they will instead become link stubs that point to the canonical file or section.

## Subjects and directories

- policies → `docs/policies/`
- architecture → `docs/architecture/`
- roles → `docs/roles/`
- inventories → `docs/inventories/`
- networking → `docs/networking/`
- terraform → `docs/terraform/`
- ansible → `docs/ansible/`
- testing → `docs/testing/`
- operations → `docs/operations/`
- security → `docs/security/`
- decisions → `docs/decisions/`
- troubleshooting → `docs/troubleshooting/`
- workflows → `docs/workflows/`
- conventions → `docs/conventions/`
- reference → `docs/reference/`
- how-to → `docs/how-to/`

## Canonicalization rules

- One canonical file per concept signature (as defined in `docs/classified.yaml`).
- Canonical docs will include full YAML front matter with `canonical_url` pointing to the file path.
- All non-canonical units for the same signature will be replaced in-place with short link stubs pointing to the canonical file or section.
- Where multiple related canonical units naturally form a flow (for example, multi-step how-tos from `README.md`), they may be merged into a single file with multiple headings; the merged file becomes the canonical destination for all merged units.

## Policy bindings

- The ALWAYS LINK policy is canonically defined at `docs/policies/always-link.md`.
- All policy mentions elsewhere (including `README.md` and `AGENTS.md`) will link to that file instead of duplicating policy text.

## Index files

- For each subject that has at least one canonical doc, an `INDEX.md` will be created under that subject directory.
- Subject index files will contain:
  - A short subject overview.
  - A table of canonical docs with titles, summaries, and links.

## Entry points

- `README.md` will be treated as HUMAN_ENTRY and will:
  - Describe the documentation layout under `docs/`.
  - Provide "Start here" tasks and quick links to common how-tos and troubleshooting docs.
  - Link to `docs/policies/always-link.md` and `docs/contributing.md`.
- `AGENTS.md` will be treated as AGENT_ENTRY and will:
  - Describe how agents should use canonical docs and indexes.
  - Require inventory, classification, and audit reports to be kept in `docs/`.
  - Emphasize the ALWAYS LINK policy for all agent-authored content.

## Ephemeral agent materials

- Files under `.agent/tmp/` are treated as design inputs only.
- If a unit sourced from `.agent/tmp/` is chosen to remain as part of the long-term documentation, its canonical doc will live under `docs/` per the normal subject/slug rules.
- Otherwise, `.agent/tmp/` content is considered non-canonical and may be deleted or ignored in future runs.