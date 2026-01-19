# SSH Client Role

Manages SSH client configuration including identity deployment and SSH config generation.

## Features

- Deploys SSH private/public key pairs for various services
- Configures SSH client config for seamless authentication
- Supports both chroot and native environments

## Variables

### Required Variables (from group_vars)
- `user_name`: The username to configure SSH for
- `install_root`: Root path for installation (empty for native)

### SSH Identities
- `user_ssh_identities`: List of SSH identity configurations (default: `[]`)

Each identity should have:
```yaml
user_ssh_identities:
  - name: github                                    # Descriptive name
    filename: github-ssh-key                        # SSH key filename (without path)
    private_key: "{{ lookup('env', 'GITHUB_SSH_PRIVATE_KEY') }}"
    public_key: "{{ lookup('env', 'GITHUB_SSH_PUBLIC_KEY') }}"
    host: github.com                                # Target host
```

## Usage

This role is automatically included in `provision.yml` after the `git` role.

### Environment Variables

For secure key management, use environment variables:

```bash
export GITHUB_SSH_PRIVATE_KEY="$(cat ~/.ssh/your_key)"
export GITHUB_SSH_PUBLIC_KEY="$(cat ~/.ssh/your_key.pub)"
```

Then configure in `group_vars/all.yml` or `host_vars`:

```yaml
user_ssh_identities:
  - name: github
    filename: github-ssh
    private_key: "{{ lookup('env', 'GITHUB_SSH_PRIVATE_KEY') }}"
    public_key: "{{ lookup('env', 'GITHUB_SSH_PUBLIC_KEY') }}"
    host: github.com
```

## What It Does

1. Deploys SSH private keys to `~/.ssh/` with mode 0600
2. Deploys SSH public keys to `~/.ssh/` with mode 0644
3. Generates `~/.ssh/config` with Host entries for each identity
4. Ensures proper ownership in both chroot and native environments

## Example SSH Config Output

With the GitHub identity configured, the role generates:

```
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github-ssh
```

This allows seamless Git operations:

```bash
git clone git@github.com:username/repo.git
```

## Security

- Private keys are deployed with mode `0600` (owner read/write only)
- Public keys are deployed with mode `0644` (world-readable)
- SSH config is deployed with mode `0600` (owner read/write only)
- Private key content is not logged (uses `no_log: true`)

## Related Roles

- **sshd**: Manages SSH server configuration (daemon)
- **git**: Configures Git user identity (uses SSH keys deployed by this role)
