# Guidelines for AI Agents

This repository uses a canonical docs system under `docs/`. All detailed policies live there.

## Quick Reference

- **Start here**: [`docs/agent/INDEX.md`](docs/agent/INDEX.md:1)
- **Contributing**: [`docs/contributing.md`](docs/contributing.md:1)
- **Always Link policy**: [`docs/agent/policies/always-link.md`](docs/agent/policies/always-link.md:1)
- **Update docs workflow**: [`docs/agent/workflows/update-docs.md`](docs/agent/workflows/update-docs.md:1)

## Agent Skills & Commands

This repository provides OpenCode skills and commands for documentation workflows.

### Commands (run with `/command-name`)

- **`/doc-inventory`**: Scan and inventory documentation
- **`/doc-classify`**: Classify docs by subject/type/scope
- **`/doc-audit`**: Audit docs for broken links

### Skills (load with `skill()`)

- **[update-docs](.opencode/skills/update-docs/SKILL.md)**: Complete workflow for updating documentation
- **[canonical-docs](.opencode/skills/canonical-docs/SKILL.md)**: Always Link policy definition
- **[agent-instructions](.opencode/skills/agent-instructions/SKILL.md)**: General rules for AI agents

## Key Rules

1. Use `.agent/` for working files (not committed)
2. Prefer canonical docs under `docs/` - don't duplicate
3. Run `/doc-audit` after doc changes
4. User instructions win over policies

## For Docs Changes

Use the update-docs skill or run commands directly:

```
skill({ name: "update-docs" })
```

Or run commands individually:
```
/doc-inventory
/doc-classify
/doc-audit
```
