---
name: github-branch-management
description: Create, manage, and merge GitHub branches following conventional commit standards. Use when working with git branches, creating PRs, or committing code changes.
compatibility: Requires GitHub MCP server configured with GITHUB_PERSONAL_ACCESS_TOKEN
metadata:
  author: trackforce
  version: "1.0"
---

# GitHub Branch Management

## When to use this skill

Use this skill when the user needs to:
- Create new branches with proper naming conventions
- Make commits following conventional commit format
- Create pull requests with proper descriptions
- Merge branches with appropriate strategies
- Manage branch lifecycle (create, update, delete)

## Branch Naming Conventions

Follow these patterns for branch names:

| Type | Pattern | Example | When to Use |
|------|---------|---------|-------------|
| `feature/` | `feature/description` | `feature/user-authentication` | New features or enhancements |
| `fix/` | `fix/description` | `fix/login-validation` | Bug fixes |
| `chore/` | `chore/description` | `chore/update-dependencies` | Maintenance tasks |
| `docs/` | `docs/description` | `docs/api-reference` | Documentation updates |
| `refactor/` | `refactor/description` | `refactor/auth-module` | Code refactoring |
| `test/` | `test/description` | `test/integration-suite` | Test additions |

**Rules**:
- Use lowercase with hyphens (kebab-case)
- Be descriptive but concise
- No special characters except hyphens
- Maximum 50 characters

## Conventional Commit Format

All commits MUST follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Commit Types

| Type | Purpose | Example |
|------|---------|---------|
| `feat` | New feature | `feat(auth): add OAuth2 support` |
| `fix` | Bug fix | `fix(api): handle null response` |
| `docs` | Documentation | `docs(readme): update installation steps` |
| `style` | Formatting | `style(ui): fix button alignment` |
| `refactor` | Code restructuring | `refactor(db): optimize query performance` |
| `test` | Tests | `test(auth): add login unit tests` |
| `chore` | Maintenance | `chore(deps): update dependencies` |
| `perf` | Performance | `perf(api): cache frequent queries` |
| `ci` | CI/CD | `ci(github): add automated tests` |
| `build` | Build system | `build(webpack): update config` |
| `revert` | Revert changes | `revert: feat(auth): add OAuth2` |

### Commit Message Guidelines

**Subject line** (first line):
- Max 72 characters
- Imperative mood ("add" not "added" or "adds")
- No period at the end
- Lowercase after type/scope

**Body** (optional):
- Wrap at 72 characters
- Explain what and why, not how
- Separate from subject with blank line

**Footer** (optional):
- Breaking changes: `BREAKING CHANGE: description`
- Issue references: `Closes #123`, `Fixes #456`

### Examples

```
feat(auth): add JWT token refresh mechanism

Implements automatic token refresh before expiration.
Reduces user session interruptions.

Closes #234
```

```
fix(api): prevent race condition in user creation

Added mutex lock to ensure atomic user creation.
Prevents duplicate user records.

BREAKING CHANGE: User creation endpoint now returns 201 instead of 200
```

## GitHub MCP Tools Usage

### Creating a Branch

Use `mcp-github-mcp-create_branch`:

```
<use_mcp_tool>
  <server_name>github-mcp</server_name>
  <tool_name>create_branch</tool_name>
  <arguments>{
    "owner": "repository-owner",
    "repo": "repository-name",
    "branch": "feature/new-feature-name",
    "from_branch": "main"
  }</arguments>
</use_mcp_tool>
```

### Creating a Pull Request

Use `mcp-github-mcp-create_pull_request`:

```
<use_mcp_tool>
  <server_name>github-mcp</server_name>
  <tool_name>create_pull_request</tool_name>
  <arguments>{
    "owner": "repository-owner",
    "repo": "repository-name",
    "title": "feat(auth): add OAuth2 support",
    "body": "## Description\n\nImplements OAuth2 authentication...\n\n## Changes\n- Added OAuth2 provider\n- Updated auth middleware\n\nCloses #123",
    "head": "feature/oauth2-support",
    "base": "main",
    "draft": false
  }</arguments>
</use_mcp_tool>
```

### Listing Branches

Use `mcp-github-mcp-list_branches`:

```
<use_mcp_tool>
  <server_name>github-mcp</server_name>
  <tool_name>list_branches</tool_name>
  <arguments>{
    "owner": "repository-owner",
    "repo": "repository-name"
  }</arguments>
</use_mcp_tool>
```

### Merging a Pull Request

Use `mcp-github-mcp-merge_pull_request`:

```
<use_mcp_tool>
  <server_name>github-mcp</server_name>
  <tool_name>merge_pull_request</tool_name>
  <arguments>{
    "owner": "repository-owner",
    "repo": "repository-name",
    "pullNumber": 123,
    "merge_method": "squash",
    "commit_title": "feat(auth): add OAuth2 support (#123)",
    "commit_message": "Implements OAuth2 authentication with JWT tokens"
  }</arguments>
</use_mcp_tool>
```

## Workflow Patterns

### Feature Development Workflow

1. **Create and checkout feature branch** from `main`:
    ```
    git checkout -b feature/descriptive-name
    ```
   This creates the branch AND switches to it in one step.

2. **Make commits** following conventional format:
   ```
   feat(module): add new functionality
   fix(module): resolve specific issue
   docs(module): update documentation
   ```

3. **Create pull request** with:
   - Clear title following conventional format
   - Description with context and changes
   - Link to related issues

4. **Merge** using appropriate strategy:
   - `squash`: For feature branches (recommended)
   - `merge`: For release branches
   - `rebase`: For clean history (use with caution)

### Hotfix Workflow

1. **Create and checkout fix branch** from `main`:
   ```
   git checkout -b fix/critical-bug-description
   ```

2. **Make fix commit**:
   ```
   fix(critical): resolve production issue

   Detailed explanation of the fix.

   Fixes #urgent-issue-number
   ```

3. **Create PR** with `urgent` or `hotfix` label

4. **Merge immediately** after review using `squash`

### Release Workflow

1. **Create and checkout release branch**:
   ```
   git checkout -b release/v1.2.0
   ```

2. **Make version bump commit**:
   ```
   chore(release): bump version to 1.2.0
   ```

3. **Create PR** to `main` with changelog

4. **Merge** using `merge` strategy to preserve history

## Best Practices

1. **Always pull latest** before creating a branch
2. **Keep branches short-lived** (< 1 week)
3. **One feature per branch** - avoid scope creep
4. **Commit frequently** with meaningful messages
5. **Rebase on main** regularly to avoid conflicts
6. **Delete merged branches** to keep repository clean
7. **Use draft PRs** for work-in-progress
8. **Request reviews** before merging
9. **Run tests** before creating PR
10. **Update documentation** in the same PR

## Common Mistakes to Avoid

- ❌ Vague branch names: `fix-stuff`, `updates`
- ❌ Non-conventional commits: `fixed bug`, `WIP`
- ❌ Missing scope in commits when applicable
- ❌ Long-lived feature branches
- ❌ Committing directly to `main`
- ❌ Force pushing to shared branches
- ❌ Merging without review
- ❌ Incomplete PR descriptions

## Reference Materials

For detailed conventional commit specification, see [`references/CONVENTIONS.md`](references/CONVENTIONS.md).

## Troubleshooting

### Branch Already Exists
If branch creation fails due to existing branch:
1. List branches to verify
2. Use different branch name or delete old branch
3. Ensure you're not accidentally recreating a merged branch

### Merge Conflicts
If PR has conflicts:
1. Pull latest `main` into your branch
2. Resolve conflicts locally
3. Commit resolution with message: `chore: resolve merge conflicts`
4. Push updated branch

### Failed CI/CD
If automated checks fail:
1. Review CI logs in PR
2. Fix issues locally
3. Commit fixes following conventional format
4. Push to update PR
