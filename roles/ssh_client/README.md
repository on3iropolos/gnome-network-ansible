# SSH Client Role

Manages SSH client configuration including identity deployment and SSH config generation.

## Features

- Deploys SSH private/public key pairs for various services
- Configures SSH client config for seamless authentication
- Supports both chroot and native environments
- Installs and configures GNOME Keyring for automatic SSH key management

## Variables

### Required Variables (from group_vars)
- `user_name`: The username to configure SSH for
- `install_root`: Root path for installation (empty for native)

### SSH Identities
- `user_ssh_identities`: List of SSH identity configurations (default: `[]`)

### GNOME Keyring
- `ssh_client_gnome_keyring_enabled`: Enable GNOME Keyring integration (default: `true`)
- `ssh_client_gnome_keyring_packages`: Packages to install (default: `[gnome-keyring, gcr]`)

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
5. Installs GNOME Keyring and GCR packages for SSH agent
6. Configures SSH_AUTH_SOCK environment via environment.d
7. Adds SSH keys to GCR SSH agent for automatic unlock on login

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

## GCR SSH Agent Integration

The role installs and configures GCR (GNOME Crypto Runtime) SSH agent for automatic SSH key management:

### How It Works

1. Packages installed: `gnome-keyring` and `gcr` (provides gcr-ssh-agent)
2. SSH_AUTH_SOCK environment configured via `~/.config/environment.d/ssh-auth-socket.conf`
3. `gcr-ssh-agent.socket` systemd unit provides the SSH agent socket
4. SSH keys are added to the agent via `ssh-add`
5. Keys are cached securely in the GNOME Keyring
6. SSH keys are available without re-entering passphrases

### Requirements

- Desktop environment with systemd user session support (DMS, GNOME, etc.)
- For console-only systems, additional configuration may be needed

### Post-Install

After provisioning and reboot, the SSH agent should be ready. If keys are not available, restart the session:

### Disabling

To disable GNOME Keyring integration:

```yaml
ssh_client_gnome_keyring_enabled: false
```

## Related Roles

- **sshd**: Manages SSH server configuration (daemon)
- **git**: Configures Git user identity (uses SSH keys deployed by this role)
