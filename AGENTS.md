# Guidelines for AI Agents

This repository treats documentation as a first-class system. Your job as an agent is to use that system correctly and keep it consistent.

This guide explains **how to navigate the docs**, **what rules you must follow**, and gives a **short checklist for updating docs as an agent**. It does **not** duplicate the canonical policies; it links to them.

---

## 1. Where to start

Human- and agent-facing documentation is organized under the `docs/` tree using subject-based folders (policies, architecture, troubleshooting, reference, how-to, and others).

For the authoritative view of this system, start from these canonical docs:

- Agent docs index: [`docs/agent/INDEX.md`](docs/agent/INDEX.md:1)  
  - Entry point for **all agent-focused** docs (policies, workflows, commands).

- Contributing docs: [`docs/contributing.md`](docs/contributing.md:1)  
  - How to add and maintain docs using the subject-based layout, YAML front matter, canonical docs, and link stubs.

- Documentation policies index: [`docs/policies/INDEX.md`](docs/policies/INDEX.md:1)  
  - Repository-wide documentation policies, including log and content guidelines.

- Always Link policy (canonical): [`docs/agent/policies/always-link.md`](docs/agent/policies/always-link.md:1)  
  - “One canonical doc per concept, link stubs everywhere else.”

HUMAN entrypoint:

- Project README: [`README.md`](README.md:1)

AGENT entrypoint (this file):

- Agent guide: [`AGENTS.md`](AGENTS.md:1)

---

## 2. High-level rules and safety

When operating in this repository:

- **Prefer canonical docs under `docs/`**  
  - Long-form explanations belong in `docs/`, not in `README.md`, `AGENTS.md`, or inline comments.  
  - If you see duplicated explanations, move the shared part into a canonical doc and leave link stubs behind.

- **Respect the Always Link policy**  
  - Ensure there is **exactly one** canonical doc per concept.  
  - Other occurrences become short stubs that point to the canonical doc or section.  
  - See [`docs/agent/policies/always-link.md`](docs/agent/policies/always-link.md:1).

- **Use `.agent/` as your working area**  
  - Temporary inventories, classifications, audits, and scratch materials live under `.agent/tmp/`.  
  - Logs for non-trivial runs live under `.agent/log/`.  
  - Follow the operational policies under `docs/agent/policies/` (workspace, logging, working directory, etc.).

- **Prefer scripted, idempotent changes**  
  - Use `.agent` tools instead of ad-hoc parsing when possible.  
  - Keep changes repeatable: re-running the workflow should not create duplicate docs or inconsistent links.

- **User instructions win for the current task**  
  - As long as they do not obviously break the repository or corrupt canonical docs.  
  - If you must deviate from a policy to satisfy an explicit request, keep the change as local and reversible as possible.

For detailed expectations, see the general agent policy:  
[`docs/agent/policies/general-instructions.md`](docs/agent/policies/general-instructions.md:1).

---

## 3. Checklist: updating docs as an agent

Use this checklist whenever you add, restructure, or significantly edit documentation (including `docs/`, `README.md`, and `AGENTS.md`):

1. **Read constraints and goals**
   - Skim the project overview in [`README.md`](README.md:1).  
   - Review the agent docs index: [`docs/agent/INDEX.md`](docs/agent/INDEX.md:1).  
   - Review contributing and policies:  
     - [`docs/contributing.md`](docs/contributing.md:1)  
     - [`docs/policies/INDEX.md`](docs/policies/INDEX.md:1)  
     - [`docs/agent/policies/always-link.md`](docs/agent/policies/always-link.md:1)

2. **Run inventory and classification (when changing structure or concepts)**
   - Inventory: `python3 .agent/doc_inventory.py`  
   - Classification: `python3 .agent/doc_classify.py`  
   - See command reference: [`docs/agent/commands/INDEX.md`](docs/agent/commands/INDEX.md:1).

3. **Decide canonical targets**
   - For each concept you are touching, decide whether you will:  
     - Update an existing canonical doc under `docs/`, or  
     - Create a new canonical doc under `docs/<subject>/<slug>.md`, or  
     - Replace legacy text with a short link stub to an existing canonical doc.
   - Ensure there is **one** canonical file per concept.

4. **Edit docs using the contributing rules**
   - Follow the front matter schema and subject layout in [`docs/contributing.md`](docs/contributing.md:1).  
   - Keep canonical docs bite-sized (usually 200–600 words).  
   - Avoid duplicating explanations; prefer link stubs to canonical docs or anchors.

5. **Run the link audit**
   - `python3 .agent/doc_audit.py`  
   - Inspect the audit report under `.agent/tmp/` for:  
     - Broken/invalid links.  
     - Oversize docs that should be split.  
     - Multiple canonical docs for the same concept.  
   - Fix issues or note them clearly if intentionally deferred.

6. **Log the run**
   - Write or update a log entry under `.agent/log/` according to:  
     - Agent workspace/logging policies under `docs/agent/policies/`.  
     - Log naming/content guidelines under `docs/policies/`.  
   - Make sure the log explains what was changed and which tools were run.

Once this checklist is complete, your documentation change is normally considered consistent with the repository’s agentic documentation system.

---

## 4. When in doubt

If you are uncertain:

1. Prefer linking to an existing canonical doc rather than creating a new explanation.
2. Defer non-essential content changes to a smaller, follow-up change set.
3. Keep diffs as tight as possible around the requested work.

When conflicts arise between this file and a canonical policy under `docs/`, **treat the canonical doc under `docs/` as the source of truth** and update this file to match via minimal edits.
