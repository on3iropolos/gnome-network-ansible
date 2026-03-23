# Long-term Memory (Layer 2)

## System Context
- **Repository**: gnome-network-ansible
- **Type**: Ansible playbook for Arch Linux workstation configuration
- **Core Functionality**: Automated provisioning and configuration management

## Project Standards
- **Language**: Ansible YAML
- **Testing**: Molecule for role testing
- **Linting**: ansible-lint
- **Documentation**: Markdown in `docs/`

## Durable Facts
- Memory Structure: Three-layer stack in `.agent/`
- GNOME Keyring v46+ moved SSH to `gcr-ssh-agent` (not in gnome-keyring-daemon)
- gcr package auto-enables `gcr-ssh-agent.socket` via systemd preset
- SSH_AUTH_SOCK set via `~/.config/environment.d/ssh-auth-socket.conf`
- keychain is deprecated for this setup; use GCR instead

## Distilled Wisdom
- Always test on stump before merging
- gcr package handles SSH agent socket enablement automatically
- PAM configuration for keyring unlock is optional (DE handles it)

## Multi-Workstation Notes
- stump: COSMIC/niri desktop environment
- whimsyforge: GNOME desktop environment
- gnome and qemu roles restricted to whimsyforge via `when:` conditions
- aur and spotify roles also run on whimsyforge only (review if needed)
- User is "on3i" with fish shell on both machines
- SSH keys managed via GCR (not keychain)
