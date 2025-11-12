# Role Name: `network`

## Description

This role configures the basic network stack on a target host, preparing it for general use. It installs essential networking tools, enables NetworkManager to handle connections, and ensures time synchronization is active. The role is designed to be idempotent and is aware of containerized environments, adjusting its behavior accordingly.

The configuration process is as follows:

```mermaid
graph TD
    A[Start: Role Execution] --> B{Detect if in Container};
    B --> C[Install Networking Tools];
    C --> D[Enable/Start Time Sync (systemd-timesyncd)];
    D --> E[Start & Enable NetworkManager and sshd];
    E --> F[Stop & Disable systemd-networkd];
    F --> G[End: Network Configured];
```

## Requirements

-   **Ansible version:** `2.9+`
-   **Operating System:** **Arch Linux** (due to package names like `netctl`).
-   **Permissions:** Requires `become: true` to install packages and manage systemd services.

## Role Variables

This role does not expose any configurable variables. Its behavior is consistent across all runs, with the exception of minor adjustments for container environments which are detected automatically.

## Dependencies

None.

## Example Playbook

To use this role, include it in your playbook. It is recommended to run it on all hosts that require a standardized network setup.

```yaml
- hosts: all
  become: true
  roles:
    - role: network
```

## License

See the LICENSE file in the root of the repository.

## Author Information

Gnome Network Ansible project
