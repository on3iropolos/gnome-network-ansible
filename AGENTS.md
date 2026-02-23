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
- **[github-branch-management](.opencode/skills/github-branch-management/SKILL.md)**: Branch and commit conventions
- **[agent-memory](.opencode/skills/agent-memory/SKILL.md)**: Three-layer memory system

## Key Rules

1. Use `.agent/` for working files (not committed)
2. Prefer canonical docs under `docs/` - don't duplicate
3. Run `/doc-audit` after doc changes
4. User instructions win over policies

## GitHub MCP Server

This repository supports the GitHub MCP Server for GitHub operations.

### Configuration

1. Copy `.env.example.github-mcp` to `~/.env/github-mcp.env` and add your GitHub PAT
2. Add to `~/.config/opencode/opencode.json`:

```json
{
  "mcp": {
    "github": {
      "type": "remote",
      "url": "https://api.githubcopilot.com/mcp/",
      "enabled": true
    }
  }
}
```

### Required Scopes

Your GitHub Personal Access Token needs:
- `repo` - Repository operations
- `read:org` - Organization team access (if using org features)

### Tools Available

With GitHub MCP Server, agents can:
- Browse and search repositories
- Manage issues and pull requests
- View and trigger GitHub Actions
- Analyze code and security findings

## Agent Memory

This repository uses a three-layer memory system in `.agent/`.

### Layers

| Layer | File/Directory | Purpose |
|-------|----------------|---------|
| 1 | `.agent/memory/` | Daily logs - ephemeral |
| 2 | `.agent/MEMORY.md` | Long-term facts - durable |
| 3 | `.agent/NOW.md` | Current context - operational |

### Usage

- **Start of session**: Read MEMORY.md and NOW.md
- **During work**: Log progress to memory/YYYY-MM-DD.md
- **End of session**: Extract insights to MEMORY.md, update NOW.md

See [agent-memory](.opencode/skills/agent-memory/SKILL.md) for full documentation.

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
