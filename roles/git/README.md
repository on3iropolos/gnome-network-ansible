# Git Role

Configures Git user identity for version control operations.

## Features

- Configures global Git user name and email
- Supports both chroot and native environments
- Uses templates for clean, maintainable configuration

## Variables

### Required Variables (from group_vars)
- `user_name`: The username to configure Git for
- `install_root`: Root path for installation (empty for native)

### Git Configuration
- `git_user_name`: Git global user.name (default: from `GIT_USER_NAME` env var or 'username')
- `git_user_email`: Git global user.email (default: from `GIT_USER_EMAIL` env var or 'user@example.com')

## Usage

This role is automatically included in `provision.yml` after the `user` role.

### Environment Variables

For customization, use environment variables:

```bash
export GIT_USER_NAME="Your Name"
export GIT_USER_EMAIL="your.email@example.com"
```

Or configure directly in `group_vars/all.yml` or `host_vars`:

```yaml
git_user_name: "Your Name"
git_user_email: "your.email@example.com"
```

## What It Does

1. Creates `.gitconfig` with user name and email
2. Ensures proper ownership in both chroot and native environments

## SSH Keys for Git

SSH identity management (keys and config) is handled by the **`ssh_client` role**, not this role. See the `ssh_client` role documentation for configuring SSH keys for Git operations.

## Example

After running this role, Git will be configured with your identity:

```bash
$ git config --global user.name
Your Name

$ git config --global user.email
your.email@example.com
```

