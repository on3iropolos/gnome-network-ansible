# Role: `brave`

## Description

Installs Brave Browser from the Arch User Repository (AUR).

```mermaid
graph TD
    A[Start: Role Execution] --> B{Install AUR helper?};
    B -- Yes --> C[Use aur role first];
    B -- No --> D[Install brave-bin via AUR];
    C --> D;
    D --> E{Verify Installation?};
    E -- Yes --> F[Check /usr/bin/brave exists];
    E -- No --> G[End: Role Completed];
    F --> G;
```

## Requirements

- Arch Linux
- AUR helper (paru - installed by `aur` role)

## Role Variables

| Variable | Default Value | Description |
| -------- | ------------- | ----------- |
| `verify_enabled` | `true` | Run verification tasks |

## Dependencies

- `aur` role - provides AUR build environment with `aur_builder` user

## Example Playbook

```yaml
- hosts: workstations
  become: true
  roles:
    - role: aur
    - role: brave
```

## License

See LICENSE file in the root of the repository.