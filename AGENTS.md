# Agent Reference

## Quick Reference

- **Start here**: [`docs/agent/INDEX.md`](docs/agent/INDEX.md:1)
- **Contributing**: [`docs/contributing.md`](docs/contributing.md:1)
- **Always Link policy**: [`docs/agent/policies/always-link.md`](docs/agent/policies/always-link.md:1)

## Agent Skills & Commands

### Commands (run with `/command-name`)

- **`/doc-inventory`**: Scan and inventory documentation
- **`/doc-classify`**: Classify docs by subject/type/scope
- **`/doc-audit`**: Audit docs for broken links

### Skills (load with `skill()`)

- **[agent-memory](.opencode/skills/agent-memory/SKILL.md)**: Three-layer memory system
- **[update-docs](.opencode/skills/update-docs/SKILL.md)**: Complete workflow for updating documentation
- **[canonical-docs](.opencode/skills/canonical-docs/SKILL.md)**: Always Link policy definition
- **[github-branch-management](.opencode/skills/github-branch-management/SKILL.md)**: Branch and commit conventions
- **[github-issue-management](.opencode/skills/github-issue-management/SKILL.md)**: GitHub Issues CRUD, labels, milestones

## Key Rules

1. At session start, load: skill({ name: "agent-memory" })
2. Use `.agent/` for working files (not committed)
3. Prefer canonical docs under `docs/` - don't duplicate
4. Use update-docs skill for doc changes
5. Run `/doc-audit` after doc changes
6. User instructions win over policies
