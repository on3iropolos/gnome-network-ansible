# Role: `antigravity`

## Description

Installs the Antigravity software from the AUR using `yay`.

## Requirements

- Arch Linux
- `yay` (configured in `aur` role)
- A non-root user with sudo privileges

## Role Variables

| Variable | Default Value | Description |
| -------- | ------------- | ----------- |
| `user_name` | (required) | The user to run yay as. |

## Example Playbook

```yaml
- roles:
    - role: aur
    - role: antigravity
```

## Note

This role is skipped during chroot (Phase 1) as AUR builds require a full environment and non-root access.
