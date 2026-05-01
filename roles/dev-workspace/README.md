# dev-workspace

Creates the development workspace structure and clones configured repositories.

## Overview

This role sets up `~/projects/personal/` directory and clones GitHub repositories using SSH. Supports both dynamic (fetch all org repos via `gh` CLI) and static (hardcoded list) modes.

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `workspace_base` | `/home/{{ user_name }}/projects` | Base workspace path |
| `workspace_org` | `on3iropolos` | GitHub organization to fetch repos from |
| `workspace_dynamic_clone` | `true` | Use `gh` CLI to fetch org repos dynamically |
| `workspace_repos` | List of 3 repos | Static fallback repos (used if dynamic fails) |
| `verify_enabled` | `true` | Enable verification tasks |

## Modes

### Dynamic Mode (default)
- Requires `github_cli` role (provides `gh` CLI)
- Fetches all non-archived repos from `workspace_org`
- Clones both public and private repos (uses authenticated `gh`)
- Falls back to static list if `gh` command fails

### Static Mode
- Set `workspace_dynamic_clone: false`
- Clones only repos defined in `workspace_repos`

## Dependencies

Requires: `user`, `git`, `ssh_client`, `github_cli` roles (github_cli needed for dynamic mode)
