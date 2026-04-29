# Agent Reference

## Quick Reference

- **Start here**: [`docs/agent/INDEX.md`](docs/agent/INDEX.md:1)
- **Contributing**: [`docs/contributing.md`](docs/contributing.md:1)
- **Always Link policy**: [`docs/agent/policies/always-link.md`](docs/agent/policies/always-link.md:1)
- **Hindsight**: Memory plugin auto-recalls on session start, auto-retains on idle
  - Bank: `gnome-network-ansible`
  - API: http://localhost:8888 | UI: http://localhost:9999
  - Tools: `hindsight_retain`, `hindsight_recall`, `hindsight_reflect`

## Agent Skills & Commands

### Commands (run with `/command-name`)

- **`/doc-inventory`**: Scan and inventory documentation
- **`/doc-classify`**: Classify docs by subject/type/scope
- **`/doc-audit`**: Audit docs for broken links

### Skills (load with `skill()`)

- **[update-docs](.opencode/skills/update-docs/SKILL.md)**: Complete workflow for updating documentation
- **[canonical-docs](.opencode/skills/canonical-docs/SKILL.md)**: Always Link policy definition
- **[github-branch-management](.opencode/skills/github-branch-management/SKILL.md)**: Branch and commit conventions
- **[github-issue-management](.opencode/skills/github-issue-management/SKILL.md)**: GitHub Issues CRUD, labels, milestones

## Key Rules

1. Use `docs/` for canonical docs - don't duplicate
2. Use update-docs skill for doc changes
3. Run `/doc-audit` after doc changes
4. User instructions win over policies
