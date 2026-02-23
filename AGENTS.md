# Guidelines for AI Agents

This repository uses a canonical docs system under `docs/`. All detailed policies live there.

## Quick Reference

- **Start here**: [`docs/agent/INDEX.md`](docs/agent/INDEX.md:1)
- **Contributing**: [`docs/contributing.md`](docs/contributing.md:1)
- **Always Link policy**: [`docs/agent/policies/always-link.md`](docs/agent/policies/always-link.md:1)
- **Update docs workflow**: [`docs/agent/workflows/update-docs.md`](docs/agent/workflows/update-docs.md:1)

## Key Rules

1. Use `.agent/` for working files (not committed)
2. Prefer canonical docs under `docs/` - don't duplicate
3. Run `python3 .agent/doc_audit.py` after doc changes
4. User instructions win over policies

## For Docs Changes

Follow the workflow: inventory → classify → edit → audit → log
