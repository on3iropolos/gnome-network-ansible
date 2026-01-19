# Role: `bitwarden`

## Description

Installs the Bitwarden desktop client. Bitwarden is available in the Arch Linux `extra` repository.

## Requirements

- Arch Linux
- `pacman` (managed via `ansible.builtin.package`)

## Role Variables

None. Uses global `install_root` to determine if running in chroot.

## Example Playbook

```yaml
- roles:
    - role: bitwarden
```
