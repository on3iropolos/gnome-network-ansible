# Agent Workspace

This directory is a **temporary scratchpad** for ephemeral working files. It complements the durable memory layers by providing a space for transient work that doesn't belong in the permanent knowledge base.

## Purpose

The workspace is designed for:
- **Task breakdowns**: Detailed plans, step-by-step checklists, and subtask decomposition
- **Temporary outputs**: Intermediate results, draft content, and working files
- **Scratch notes**: Quick observations, temporary analysis, and exploratory work
- **Active context**: Files needed during current work that will be discarded or promoted

## Memory vs. Workspace

| Aspect | Memory (Layers 1-3) | Workspace |
|--------|---------------------|-----------|
| **Purpose** | Durable, searchable knowledge base | Temporary scratchpad |
| **Lifespan** | Permanent (or archived) | Ephemeral (cleaned regularly) |
| **Content** | Facts, decisions, wisdom, context | Plans, drafts, temporary outputs |
| **Audience** | Agent + Human | Agent + Human |
| **Searchable** | Yes (indexed for retrieval) | No (transient by design) |

## Characteristics

- **Not committed to version control**: Excluded from git
- **Ephemeral**: Files can be deleted without loss of critical information
- **Short-lived**: Content should be promoted to memory or discarded after use
- **Flexible**: No strict format requirements; use what works for the task

## Best Practices

### For Agents
1. **Use for active work**: Store task lists, plans, and temporary outputs here
2. **Promote important insights**: Move valuable information to `../MEMORY.md` or `../NOW.md`
3. **Clean regularly**: Remove obsolete files after task completion
4. **Organize by task**: Use subdirectories or clear naming for different work streams

### For Humans
1. **Review before cleaning**: Check workspace for insights before deletion
2. **Don't rely on workspace**: Assume files may be deleted at any time
3. **Extract value**: Promote useful content to permanent memory layers
4. **Clean periodically**: Remove stale files to maintain workspace hygiene

## Example Use Cases

- Breaking down complex tasks into subtasks
- Storing intermediate analysis results
- Drafting documentation before finalizing
- Maintaining temporary checklists
- Collecting research notes during investigation
- Prototyping code snippets or configurations
- Tracking progress on multi-step workflows

## Workflow

```
1. Agent starts task → Creates workspace files (plans, checklists)
2. Agent works → Updates workspace files with progress
3. Task completes → Extract insights to MEMORY.md or NOW.md
4. Cleanup → Delete workspace files or archive if needed
```

---

*This workspace keeps your permanent memory layers clean while providing flexibility for active work. Clean regularly to maintain hygiene.*
