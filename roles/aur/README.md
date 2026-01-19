# Role: `aur`

## Description

Installs the `yay-bin` AUR helper. This enables subsequent roles to install packages from the Arch User Repository.

## Requirements

- Arch Linux
- A non-root user with sudo privileges (configured in `user` role)
- `base-devel` and `git`

## Role Variables

| Variable | Default Value | Description |
| -------- | ------------- | ----------- |
| `user_name` | (required) | The user to build and install yay as. |

## Example Playbook

```yaml
- roles:
    - role: user
    - role: aur
```

## Note

AUR installation is skipped if `install_root` is set (e.g., during Phase 1/Chroot builds) to ensure reliability.
