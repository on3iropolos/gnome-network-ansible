---
name: agent-memory
description: Three-layer memory system for AI agents. Use at session start to read context, and during work to log insights and extract durable facts.
compatibility: opencode
metadata:
  repo: gnome-network-ansible
---

# Agent Memory

## Overview

This repository uses a three-layer memory system to maintain context across sessions and capture durable knowledge.

## Layers

| Layer | File | Purpose |
|-------|------|---------|
| 1 | `.agent/memory/YYYY-MM-DD.md` | Daily working logs - ephemeral |
| 2 | `.agent/MEMORY.md` | Long-term facts and wisdom - durable |
| 3 | `.agent/NOW.md` | Current task context - operational |

## When to Use

### At Session Start

1. Read `.agent/MEMORY.md` for project context
2. Read `.agent/NOW.md` for current priorities
3. Check `.agent/memory/` for recent activity

### During Work

1. Log progress to `.agent/memory/YYYY-MM-DD.md`
2. Create temporary files in `.agent/workspace/`
3. Note discoveries, decisions, and insights

### At Session End

1. Extract durable facts to `.agent/MEMORY.md`
2. Update `.agent/NOW.md` with current state
3. Clean up `.agent/workspace/` if needed

## Best Practices

- **Layer 1 is ephemeral**: Don't rely on daily logs persisting forever
- **Layer 2 is durable**: Only store facts that won't change
- **Layer 3 is operational**: Keep current, update as tasks progress
- **Link don't duplicate**: Reference docs instead of copying content
- **Promote insights**: Move valuable observations from daily logs to MEMORY.md

## File Purposes

### Layer 1: Daily Logs (`.agent/memory/`)

- Task breakdown and progress
- Research findings
- Draft content and working notes
- Scratch calculations

### Layer 2: Long-term Memory (`.agent/MEMORY.md`)

- Project architecture facts
- Key conventions and standards
- Lessons learned (extracted from daily logs)
- Important relationships between components

### Layer 3: Now (`.agent/NOW.md`)

- Current active tasks
- Priorities for today
- Blockers and dependencies
- Recent decisions needing follow-up

### Workspace (`.agent/workspace/`)

- Temporary files for active work
- Files that can be deleted without loss
- Intermediate drafts
- Task-specific checklists

## Related

- [canonical-docs](canonical-docs): Documentation system
- [github-branch-management](github-branch-management): Branch and commit conventions
