---
name: agent-instructions
description: High-level rules for AI agents: understand project first, respect canonical docs, prefer scripted changes, run linting. Use as entry point when starting work in this repo.
license: MIT
compatibility: opencode
metadata:
  policy: agent
  repo: gnome-network-ansible
---

# General Instructions for AI Agents

This skill summarizes the core expectations for AI agents working in this repository.

## 1. Understand the project first

Before making changes:

- Read the project overview in `README.md`
- Read the agent guide in `AGENTS.md`
- Review the Always Link policy in [canonical-docs](canonical-docs)
- Review the documentation contributor guide in `docs/contributing.md`

## 2. Follow canonical documentation rules

When working with docs:

- Treat `docs/` as the **canonical** home for concepts
- Avoid duplicating explanations; link to docs instead
- Keep commits small and focused

See [canonical-docs](canonical-docs) and `docs/contributing.md` for details.

## 3. Prefer scripted, idempotent changes

- Use the doc skills (inventory, classify, audit) instead of ad-hoc edits
- Re-running should not corrupt docs or create duplicates
- Keep diffs focused on single logical changes

## 4. Respect testing and linting

- Run `ansible-lint` before pushing
- Test roles with Molecule before submitting changes
- See `docs/reference/testing-best-practices.md`

## 5. Precedence

When instructions conflict:

1. User's direct instructions take precedence (if they don't damage the repo)
2. Repository policies guide implementation
3. Keep deviations local and reversible

## 6. Where to read more

- Always Link policy: [canonical-docs](canonical-docs)
- Documentation system: `docs/contributing.md`
- Testing best practices: `docs/reference/testing-best-practices.md`

## Related skills

- [canonical-docs](canonical-docs): Always Link policy
- [update-docs](update-docs): Complete documentation update workflow
- [doc-inventory](doc-inventory): Scan and inventory docs
- [doc-classify](doc-classify): Classify docs and detect duplicates
- [doc-audit](doc-audit): Audit docs for broken links and issues
