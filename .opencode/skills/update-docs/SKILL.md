---
name: update-docs
description: Complete workflow for updating documentation safely using Always Link policy. Steps: inventory, classify, edit, audit, log. Use when modifying docs, README, or AGENTS files.
license: MIT
compatibility: opencode
metadata:
  workflow: documentation
  repo: gnome-network-ansible
---

# Update Documentation Workflow

This skill provides the complete workflow for updating documentation safely using the Always Link policy.

## When to use this skill

Use this skill when:
- You need to add, restructure, or significantly edit files under `docs/`
- You need to update README.md or AGENTS.md
- You need to create new documentation

## Workflow Steps

### 1. Read constraints and goals

- Review project overview: `README.md`
- Review agent guide: `AGENTS.md`
- Review the Always Link policy: [canonical-docs](canonical-docs)
- Review contributing guide: `docs/contributing.md`

### 2. Run inventory and classification (when concepts or layout change)

If you're changing concepts, layout, or canonical targets:

```bash
/doc-inventory
/doc-classify
```

Or run the scripts directly:
```bash
python3 .opencode/scripts/inventory.py
python3 .opencode/scripts/classify.py
```

Use these outputs to understand existing canonical docs, duplicates, and subjects before editing.

### 3. Plan canonical changes

For each concept you touch, decide whether you will:

- Update an existing canonical doc under `docs/<subject>/<slug>.md`, or
- Create a new canonical doc under `docs/<subject>/<slug>.md`, or
- Replace legacy text with a short link stub pointing at an existing canonical doc.

Ensure there is **exactly one** canonical doc per concept.

### 4. Edit docs

While editing or creating docs:

- Follow the front matter schema and subject layout
- Keep docs bite-sized (usually 200-600 words)
- Move shared explanations into canonical docs and leave behind 1-2 sentence link stubs
- Prefer links (including section anchors) over copying content between files

### 5. Run the link audit

After your edits:

```bash
/doc-audit
```

Or run the script directly:
```bash
python3 .opencode/scripts/audit.py
```

Inspect `.agent/tmp/audit.json` for:
- Broken or incorrect links
- Oversize docs that should be split
- Multiple canonical docs claiming the same concept

Refine your changes until the audit output is clean or you clearly understand and accept any remaining findings.

### 6. Log the run

Before considering the task complete, write a log entry under `.agent/log/` following the logging policies.

Keep diffs as small as practical and ensure that re-running this workflow would not create duplicate docs or inconsistent links.

## Related

- `/doc-inventory` - Scan and inventory docs
- `/doc-classify` - Classify docs and detect duplicates
- `/doc-audit` - Audit docs for broken links and issues
- [canonical-docs](../canonical-docs/SKILL.md): Always Link policy
- [agent-instructions](../agent-instructions/SKILL.md): General agent rules
