# Guidelines for AI Agents

This document is the primary entrypoint for AI agents working with this repository. It explains how to use the canonical documentation under `docs/`, where to find agent policies, and which artifacts you must produce when manipulating docs.

You **MUST** follow this document together with the per-topic instructions in `.agent/instructions/` when making changes.

## 1. Documentation layout

Human- and agent-facing documentation is organized under the `docs/` tree using subject-based folders:

- `docs/policies/` – repository policies (including testing/linting and other repo-wide rules).
- `docs/architecture/` – high-level architecture and design docs.
- `docs/roles/` – role-centric documentation (overviews, variables, testing notes).
- `docs/terraform/` – Terraform VM testing infrastructure.
- `docs/troubleshooting/` – runbooks for common failures (for example Molecule or Terraform issues).
- `docs/reference/`, `docs/how-to/`, and other subjects – supporting concepts, references, and task-oriented guides.
- `docs/agent/` – agent-focused documentation (policies, workflows, and command references for `.agent/` tooling).

Canonical agent and documentation docs you will frequently need:

- Agent docs index: [`docs/agent/INDEX.md`](docs/agent/INDEX.md:1)
- ALWAYS LINK policy (canonical): [`docs/agent/policies/always-link.md`](docs/agent/policies/always-link.md:1)
- General instructions for AI agents (canonical): [`docs/agent/policies/general-instructions.md`](docs/agent/policies/general-instructions.md:1)
- Documentation contributing guide: [`docs/contributing.md`](docs/contributing.md:1)

HUMAN entrypoint:

- Project README: [`README.md`](README.md:1)

AGENT entrypoint (this file):

- Agent guide: [`AGENTS.md`](AGENTS.md:1)

## 2. Agent policies

Read the agent policy documents under `docs/agent/policies/`. These policies define how canonical documentation is organized, how agents are expected to behave, and how `.agent/` tooling and logging must be used.

Key entrypoint:

- Agent policies index: [`docs/agent/policies/INDEX.md`](docs/agent/policies/INDEX.md:1)

When you find overlapping explanations in different files:

1. Ensure there is a single canonical doc for the concept under `docs/<subject>/<slug>.md` with appropriate front matter.
2. Convert other occurrences into short link stubs that point at that canonical doc or a specific section.
3. Do **not** repeat long-form text in `README.md`, `AGENTS.md`, role READMEs, or inline comments; link to `docs/` instead.

## 3. Required agent outputs

For documentation refactors like the current system, agents are expected to maintain the following machine-readable artifacts:

- Inventory report: [`docs/inventory.yaml`](docs/inventory.yaml:1)
  - Extracted “documentation units” with signatures and source pointers.
- Classification report: [`docs/classified.yaml`](docs/classified.yaml:1)
  - Units tagged with `subject`, `type`, `scope`, `tags`, `canonical_doc`, and duplicate mappings.
- Link audit report (to be created): `docs/audit.json`
  - Broken/ambiguous links, duplicate concepts, and oversize docs.

When you change docs in ways that affect concepts or linking, update these files via the project’s `.agent` tooling instead of hand-editing them.

## 4. Agent workflow for docs

When performing documentation work, follow this sequence:

1. **Read constraints and goals**
   - Project overview: [`README.md`](README.md:1)
   - Agent instructions: [`AGENTS.md`](AGENTS.md:1)
   - Agent docs index and policies: [`docs/agent/INDEX.md`](docs/agent/INDEX.md:1)
   - ALWAYS LINK policy: [`docs/agent/policies/always-link.md`](docs/agent/policies/always-link.md:1)
   - Docs contributing guide: [`docs/contributing.md`](docs/contributing.md:1)

2. **Inventory and classification**
   - Use `.agent` tooling (for example [`doc_inventory.py`](.agent/doc_inventory.py:1) and [`doc_classify.py`](.agent/doc_classify.py:1)) to update:
     - [`docs/inventory.yaml`](docs/inventory.yaml:1)
     - [`docs/classified.yaml`](docs/classified.yaml:1)

3. **Author / update canonical docs**
   - Create or update canonical docs under `docs/` using the front matter schema described in [`docs/contributing.md`](docs/contributing.md:1).
   - Prefer placing **agent-focused** canonical docs under `docs/agent/` (for example `docs/agent/policies/`, `docs/agent/workflows/`, `docs/agent/commands/`) and linking to them from `AGENTS.md` or other entrypoints.
   - Preserve original source context via short “Source” notes when promoting inline comments or README sections into standalone docs.
   - Convert overlapping content in other files into link stubs.

4. **Update entrypoints**
   - Keep [`README.md`](README.md:1) focused on human quick starts and high-level structure, linking into `docs/`.
   - Keep [`AGENTS.md`](AGENTS.md:1) focused on how agents should use `docs/` and tooling, not as a second copy of policy text.
   - When adding or updating agent-specific docs, ensure they are discoverable from [`docs/agent/INDEX.md`](docs/agent/INDEX.md:1).

5. **Run link audit (once implemented)**
   - Use the future `.agent` link-audit tool to generate `docs/audit.json` and fix:
     - Broken or absolute links.
     - Multiple canonical docs for the same concept.
     - Files that exceed bite-size limits.

## 5. Subject indexes

Each populated subject directory under `docs/` (including `docs/agent/`) should eventually contain an `INDEX.md` that:

- Briefly explains the subject area.
- Lists canonical docs in that subject with titles and summaries.
- Provides quick links for common human and agent tasks.

When these index files exist, prefer linking to them from `README.md` and `AGENTS.md` instead of enumerating individual docs inline.

## 6. Legacy instruction files under .agent/instructions

In addition to this entrypoint, agents **must** honor the existing instruction files:

- General instructions: [`general_instructions.md`](.agent/instructions/general_instructions.md:1)
- Working directory & logging: [`working_directory.md`](.agent/instructions/working_directory.md:1)
- Documentation specifics: [`documentation.md`](.agent/instructions/documentation.md:1)
- Testing & linting: [`testing_and_linting.md`](.agent/instructions/testing_and_linting.md:1)
- Interaction rules: [`interaction.md`](.agent/instructions/interaction.md:1)
- Mermaid diagrams: [`mermaid_diagram_guidelines.md`](.agent/instructions/mermaid_diagram_guidelines.md:1)

These documents describe how to:

- Use `.agent/` as the working directory.
- Log activity in `.agent/log/` as required.
- Run `ansible-lint`, Molecule, and Terraform tests.
- Handle conflicting instructions between this repo and the user (user instructions take precedence for the current task).

## 7. Safety and precedence rules

When in doubt:

1. **User instructions win** for the current task, as long as they do not obviously break the repo.
2. If user instructions conflict with documentation policies:
   - Follow the user request but keep changes as local as possible.
   - Avoid deleting or corrupting canonical docs or reports unless explicitly instructed.
3. Prefer scripting changes through `.agent` tools and structured diffs rather than freehand edits.

Failure to follow these guidelines may result in inconsistent documentation and rejected changes.
