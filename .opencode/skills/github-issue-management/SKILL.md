---
name: github-issue-management
description: Manage GitHub Issues including list, create, edit, close/reopen, labels, assignees, milestones, and comments. Use with CLI (gh) or interactive prompts.
compatibility: Requires gh CLI installed and authenticated
metadata:
  repo: gnome-network-ansible
  version: "1.0"
---

# GitHub Issue Management

## When to Use This Skill

Use this skill when working with GitHub Issues:
- List/view issues with filtering options
- Create new issues with title, body, labels, assignees, milestone
- Edit existing issues (title, body, labels, assignees, milestone)
- Close or reopen issues
- Manage labels (create, delete, add to issues, remove from issues)
- Assign or unassign users
- Manage milestones
- Add, edit, or delete comments
- Perform bulk operations (close multiple, apply labels to multiple)
- Export data as JSON for scripting

## Command Pattern

Use slash commands for quick access:
- `/gh-issue <action>` - Main command
- `/issue <action>` - Short alias

Run without action to see available operations.

## List/View Operations

### List Issues

```bash
gh issue list
```

| Flag | Description | Example |
|------|-------------|---------|
| `--state` | Filter by state: `open`, `closed`, `all` | `--state all` |
| `--assignee` | Filter by assignee | `--assignee @username` |
| `--label` | Filter by label (can repeat) | `--label bug --label urgent` |
| `--milestone` | Filter by milestone number or title | `--milestone "v1.0"` |
| `--author` | Filter by author | `--author @username` |
| `--search` | Search in title/body | `--search "fix error"` |
| `--json` | Output as JSON | `--json number,title,state` |
| `--limit` | Limit number of results | `--limit 50` |

**Examples:**
```bash
gh issue list --state open --label bug
gh issue list --assignee @me --json number,title
gh issue list --search "authentication error" --state all
```

### View Single Issue

```bash
gh issue view <number>
```

| Flag | Description |
|------|-------------|
| `--json` | Output as JSON |
| `-c, --comments` | Include comments |

**Examples:**
```bash
gh issue view 123
gh issue view 123 --json
gh issue view 123 --comments
```

### Issue Status

Show your relevant issues (assigned to you, mentioning you, opened by you):

```bash
gh issue status
```

| Flag | Description |
|------|-------------|
| `--json` | Output as JSON |

**Examples:**
```bash
gh issue status
gh issue status --json
```

This is useful for quick triage and seeing what needs your attention.

## Create Operations

### Create New Issue

```bash
gh issue create --title "<title>" --body "<body>"
```

| Flag | Description |
|------|-------------|
| `--title` | Issue title (required) |
| `--body` | Issue body/description |
| `--label` | Add labels (can repeat) |
| `--assignee` | Assign users (can repeat) |
| `--milestone` | Assign milestone |

**Examples:**
```bash
gh issue create --title "Fix login bug" --body "Description here"
gh issue create --title "New feature" --label enhancement --label feature
gh issue create --title "Urgent" --assignee @user --milestone "v1.0"
```

### Interactive Create

If run without flags, `gh issue create` opens an interactive editor:
```bash
gh issue create
```

## Edit Operations

### Edit Issue

```bash
gh issue edit <number> [flags]
```

| Flag | Description |
|------|-------------|
| `--title` | Set new title |
| `--body` | Set new body |
| `--add-label` | Add labels (can repeat) |
| `--remove-label` | Remove labels (can repeat) |
| `--add-assignee` | Add assignees (can repeat) |
| `--remove-assignee` | Remove assignees (can repeat) |
| `--milestone` | Set or remove milestone (use `none`) |

**Examples:**
```bash
gh issue edit 123 --title "New title"
gh issue edit 123 --add-label bug --remove-label enhancement
gh issue edit 123 --add-assignee @user --remove-assignee @olduser
gh issue edit 123 --milestone none
```

## Close/Reopen Operations

### Close Issue

```bash
gh issue close <number>
```

| Flag | Description |
|------|-------------|
| `--comment` | Add comment while closing |

**Examples:**
```bash
gh issue close 123
gh issue close 123 --comment "Fixed in PR #456"
```

### Reopen Issue

```bash
gh issue reopen <number>
```

**Examples:**
```bash
gh issue reopen 123
```

### Delete Issue

```bash
gh issue delete <number>
```

| Flag | Description |
|------|-------------|
| `--yes` | Skip confirmation prompt |

**Warning:** This permanently deletes the issue and all its comments.

**Examples:**
```bash
gh issue delete 123
gh issue delete 123 --yes
```

## Lock/Unlock Operations

### Lock Issue

Lock an issue to prevent further comments (used for off-topic, resolved, spam, or heated discussions):

```bash
gh issue lock <number>
```

| Flag | Description |
|------|-------------|
| `-r, --reason` | Reason for locking: `off_topic`, `resolved`, `spam`, `too_heated` |

**Examples:**
```bash
gh issue lock 123
gh issue lock 123 --reason too_heated
```

### Unlock Issue

```bash
gh issue unlock <number>
```

**Examples:**
```bash
gh issue unlock 123
```

## Pin/Unpin Operations

### Pin Issue

Pin important issues to the top of the issue list:

```bash
gh issue pin <number>
```

**Examples:**
```bash
gh issue pin 123
```

### Unpin Issue

```bash
gh issue unpin <number>
```

**Examples:**
```bash
gh issue unpin 123
```

## Transfer Operations

### Transfer Issue

Move an issue to another repository:

```bash
gh issue transfer <number> <destination-repo>
```

The destination repo should be in the format `owner/repo`.

**Examples:**
```bash
gh issue transfer 123 owner/other-repo
gh issue transfer 123 my-org/my-project
```

## Label Operations

### List Labels

```bash
gh label list
```

| Flag | Description |
|------|-------------|
| `--json` | Output as JSON |

### Create Label

```bash
gh label create <name>
```

| Flag | Description |
|------|-------------|
| `--description` | Label description |
| `--color` | Hex color (without #) |

**Examples:**
```bash
gh label create bug --description "Bug reports" --color FF0000
gh label create "help wanted"
```

### Delete Label

```bash
gh label delete <name>
```

### Edit Label

Update an existing label's name, description, or color:

```bash
gh label edit <name> [flags]
```

| Flag | Description |
|------|-------------|
| `-n, --name` | New name for the label |
| `-d, --description` | New description |
| `-c, --color` | New hex color (6 characters, without #) |

**Examples:**
```bash
gh label edit bug --color FF0000
gh label edit bug --name "big-bug" --description "Larger than normal bug"
```

### Clone Labels

Copy all labels from another repository:

```bash
gh label clone <source-repo>
```

The source repo should be in the format `owner/repo`.

**Examples:**
```bash
gh label clone upstream/main
gh label clone my-org/template-repo
```

### Add Label to Issue

```bash
gh issue edit <number> --add-label <label>
```

**Examples:**
```bash
gh issue edit 123 --add-label bug
gh issue edit 123 --add-label urgent --add-label bug
```

### Remove Label from Issue

```bash
gh issue edit <number> --remove-label <label>
```

**Examples:**
```bash
gh issue edit 123 --remove-label wontfix
```

## Assignee Operations

### Assign User

```bash
gh issue edit <number> --add-assignee <username>
```

**Examples:**
```bash
gh issue edit 123 --add-assignee @username
gh issue edit 123 --add-assignee @user1 --add-assignee @user2
```

### Unassign User

```bash
gh issue edit <number> --remove-assignee <username>
```

## Milestone Operations

### List Milestones

```bash
gh milestone list
```

| Flag | Description |
|------|-------------|
| `--json` | Output as JSON |

### Create Milestone

```bash
gh milestone create <title>
```

| Flag | Description |
|------|-------------|
| `--description` | Milestone description |
| `--due-date` | Due date (YYYY-MM-DD) |
| `--json` | Output as JSON |

**Examples:**
```bash
gh milestone create "v1.0" --description "First release"
gh milestone create "v2.0" --due-date 2024-12-31
```

### Edit Milestone

```bash
gh milestone edit <number> [flags]
```

| Flag | Description |
|------|-------------|
| `--title` | Set new title |
| `--description` | Set description |
| `--due-date` | Set due date |
| `--close` | Close milestone |
| `--open` | Open milestone |

### Delete Milestone

```bash
gh milestone delete <number>
```

### Assign Milestone to Issue

```bash
gh issue edit <number> --milestone <title-or-number>
```

**Examples:**
```bash
gh issue edit 123 --milestone "v1.0"
gh issue edit 123 --milestone 5
```

## Comment Operations

### Add Comment

```bash
gh issue comment <number> --body "<comment>"
```

**Examples:**
```bash
gh issue comment 123 --body "Working on this"
```

### List Comments

```bash
gh issue view <number> --comments
```

### Edit Comment

```bash
gh issue comment <number> --edit
```

### Delete Comment

```bash
gh issue comment <number> --delete
```

## Bulk Operations

### Close Multiple Issues

```bash
gh issue close <number1> <number2> <number3>
```

Or loop in script:
```bash
for issue in 123 124 125; do gh issue close $issue; done
```

### Apply Label to Multiple Issues

```bash
for issue in 123 124 125; do gh issue edit $issue --add-label bug; done
```

### Bulk with JSON

For advanced bulk operations, combine `--json` with jq:

```bash
gh issue list --label bug --json number | jq -r '.[].number' | xargs -I {} gh issue close {}
```

## Output Formats

### JSON Output

Use `--json` with comma-separated fields:

```bash
gh issue list --json number,title,state,labels
gh issue view 123 --json number,title,body,assignees
gh label list --json name,description,color
```

Available fields for issues: `number`, `title`, `body`, `state`, `author`, `assignees`, `labels`, `milestone`, `comments`, `createdAt`, `updatedAt`, `closedAt`.

### Filtered JSON Queries

Combine with jq for scripting:

```bash
# Get all open issue numbers
gh issue list --state open --json number | jq -r '.[].number'

# Get issues with specific label
gh issue list --label enhancement --json title,number | jq -r '.[] | "\(.number): \(.title)"'
```

## Interactive Workflows

### List Issues Interactively

1. Ask user for filters (or use defaults: `--state open`)
2. Run command with filters
3. Display results in readable format

### Create Issue Interactively

1. Prompt for title (required)
2. Prompt for body (optional, opens editor if empty)
3. Prompt for labels (comma-separated, optional)
4. Prompt for assignees (comma-separated, optional)
5. Prompt for milestone (optional)
6. Confirm and create

### Edit Issue Interactively

1. Fetch current issue details
2. Show current values for each field
3. Prompt for each field to change (press Enter to keep current)
4. Confirm changes
5. Apply edits

### Manage Labels Interactively

1. List current repo labels
2. Ask user for action: create / delete / add to issue / remove from issue
3. If create: prompt for name, description, color
4. If delete: prompt for label name, confirm
5. If add/remove: prompt for issue number, then select label

### Bulk Close Interactively

1. Show list of open issues
2. Ask user to select issues (numbers, comma-separated, or "all")
3. Confirm selection
4. Close each issue
5. Report results

## Best Practices

1. **Close issues with context**: Add comment like "Fixed in PR #456" when closing
2. **Use consistent labeling**: Establish a label strategy (e.g., bug, enhancement, documentation)
3. **Link issues**: Reference issues in commits with `Closes #123` or `Fixes #456`
4. **Use milestones for releases**: Group issues by version/release
5. **JSON for automation**: Use `--json` for scripts, jq for filtering
6. **Search before creating**: Check for existing issues before creating duplicates
7. **Assign relevant people**: Assignee should be the person responsible for resolution

## Common Patterns

### Weekly Review

```bash
gh issue list --state open --assignee @me
gh issue list --state open --label bug
gh issue list --milestone "v1.0"
```

### Release Preparation

```bash
gh milestone list
gh issue list --milestone "v1.0" --state open
gh milestone edit 1 --close
```

### Bug Triage

```bash
gh issue list --label bug --state open
gh issue edit 123 --add-label "needs-triage"
gh issue edit 123 --add-assignee @triager
```

## Troubleshooting

### Authentication Error

If you get authentication errors:
1. Run `gh auth status` to check authentication
2. Run `gh auth login` to authenticate
3. Ensure you have `repo` scope for private repos

### Issue Not Found

If issue number doesn't exist:
1. Verify the issue number: `gh issue list`
2. Check if it's in a different repository
3. Use `--repo owner/repo` to specify different repo

### Permission Denied

If you can't modify an issue:
1. You must be the issue author or have repo write access
2. Check repository permissions
3. Request assignment from repo maintainer

### Label Already Exists

If label creation fails:
1. Use `gh label list` to see existing labels
2. Choose different name or delete existing label first

### Cannot Close Issue

If close fails:
1. Issue may already be closed
2. Check issue state: `gh issue view 123`

## Getting Help

### CLI Help Commands

Get help directly from the CLI:

```bash
# General help
gh help issue

# Issue-specific help
gh issue --help

# Label command help
gh label --help

# Milestone command help
gh milestone --help
```

### Online Manual

For comprehensive documentation, visit:
- **Main CLI Manual**: https://cli.github.com/manual/
- **GitHub CLI on GitHub**: https://github.com/cli/cli
- **gh issue reference**: https://cli.github.com/manual/gh_issue
- **gh label reference**: https://cli.github.com/manual/gh_label
- **gh milestone reference**: https://cli.github.com/manual/gh_milestone

### Getting Help Interactively

If you're unsure how to accomplish a task:
1. Run `gh issue --help` to see available commands
2. Check the online manual for examples
3. Ask the user for clarification

## Related

- [github-branch-management](../github-branch-management): Branch and PR management
