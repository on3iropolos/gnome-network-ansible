# Agent Reference

## Quick Reference

- **Start here**: [`docs/agent/INDEX.md`](docs/agent/INDEX.md:1)
- **Contributing**: [`docs/contributing.md`](docs/contributing.md:1)
- **Always Link policy**: [`docs/agent/policies/always-link.md`](docs/agent/policies/always-link.md:1)
- **Hindsight Memory**: Auto-recalls on session start, auto-retains on idle
  - **Bank**: `gnome-network-ansible` (shared across all workstations)
  - **API**: http://localhost:8888 | **UI**: http://localhost:9999
  - **Tools**: `hindsight_retain`, `hindsight_recall`, `hindsight_reflect`
  - **Config**: `opencode.json` (project-level plugin config)

## Agent Skills & Commands

### Commands (run with `/command-name`)

- **`/doc-inventory`**: Scan and inventory documentation
- **`/doc-classify`**: Classify docs by subject/type/scope
- **`/doc-audit`**: Audit docs for broken links

### Skills (load with `skill()`)

- **[github-branch-management](.opencode/skills/github-branch-management/SKILL.md)**: Branch and commit conventions
- **[github-issue-management](.opencode/skills/github-issue-management/SKILL.md)**: GitHub Issues CRUD, labels, milestones

## Key Rules

1. Use `docs/` for canonical docs - don't duplicate (Always Link policy)
2. Run `/doc-audit` after doc changes
4. User instructions win over policies
5. Hindsight memories persist across sessions - check recall before asking
6. Prefer `hindsight_reflect` for reasoned responses using bank's disposition
7. Use `hindsight_recall` for quick fact lookup, `hindsight_retain` for storing insights
