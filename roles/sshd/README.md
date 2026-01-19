# SSHD Role

Configures and enables the SSH daemon (sshd) for remote access.

## Features

- Enables SSH daemon (sshd) service
- Supports both chroot and native environments
- Allows remote SSH access to the system

## Variables

### Required Variables (from group_vars)
- `install_root`: Root path for installation (empty for native)

## Usage

This role is automatically included in both `install.yml` and `provision.yml`.

## What It Does

1. Enables the SSH daemon (sshd) service
2. Works in both chroot (during install) and native (post-boot) environments

## Security Considerations

- This role only enables the SSH service
- SSH hardening (port configuration, key-only auth, etc.) should be configured separately
- Consider using firewall rules to restrict SSH access

## Related Roles

- **ssh_client**: Manages SSH client configuration (identities and config)
