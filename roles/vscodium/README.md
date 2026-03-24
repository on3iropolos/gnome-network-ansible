# Role: VSCodium

## Description

Installs VSCodium (the open-source build of VS Code) from the AUR on Arch Linux. Optionally installs user extensions from the Open VSX registry.

## Requirements

- Arch Linux
- AUR helper (paru) and aur_builder user (see [`aur` role](../aur/README.md))
- `community.general` collection

## Role Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `vscodium_extensions` | `[]` | List of extension IDs to install (e.g., `ms-python.python`) |
| `verify_enabled` | `false` | Run verification tasks |

Note: Uses `user_name` from `inventories/group_vars/all.yml` for config and extensions.

## Dependencies

- [`aur`](../aur/README.md) - Sets up AUR build environment

## Example Playbook

```yaml
- hosts: workstations
  become: true
  roles:
    - role: vscodium
      vars:
        vscodium_extensions:
          - ms-python.python
          - redhat.ansible
          - hashicorp.terraform
```

## Common Extensions

| Extension | ID |
|-----------|-----|
| Python | `ms-python.python` |
| Ansible | `redhat.ansible` |
| Terraform | `hashicorp.terraform` |
| Docker | `ms-azuretools.vscode-docker` |
