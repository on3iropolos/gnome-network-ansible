# dev-workspace

Creates the development workspace structure and clones configured repositories.

## Overview

This role sets up `~/projects/personal/` directory and clones specified GitHub repositories using SSH.

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `workspace_base` | `/home/{{ user_name }}/projects` | Base workspace path |
| `workspace_repos` | List of 3 on3iropolos repos | Repositories to clone |
| `verify_enabled` | `true` | Enable verification tasks |

## Dependencies

Requires: `user`, `git`, `ssh_client` roles
