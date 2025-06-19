# Role Name: `arch-iso-install`

## Description

This role automates the installation of Arch Linux on a target machine that has been booted from the Arch Linux installation media. It is designed to set up a fully functional system including disk partitioning, optional encryption, filesystem creation (BTRFS or ext4), bootloader installation (GRUB), and basic system configuration like timezone and user creation.

Key features:
-   Automated partitioning of the target drive.
-   Optional LUKS encryption for the root partition.
-   Support for BTRFS filesystem with subvolumes, or standard ext4.
-   GRUB bootloader installation.
-   User creation with password and SSH public key.
-   System localization (timezone, hostname).

Special thanks to the following repositories for inspiration:
-   [33Fraise33/desktop-ansible](https://github.com/33Fraise33/desktop-ansible/tree/main)
-   [jsf9k/ansible-arch-install](https://github.com/jsf9k/ansible-arch-install)

The overall installation flow is as follows:

```mermaid
graph TD
    A[Start: Target Booted in Arch ISO] --> B(Define Target Drive);
    B --> C{Encryption Enabled?};
    C -- Yes --> D[Setup LUKS Encryption];
    C -- No --> E[Partition Disk];
    D --> E;
    E --> F{BTRFS Enabled?};
    F -- Yes --> G[Create BTRFS Filesystem & Subvolumes];
    F -- No --> H[Create ext4 Filesystem];
    G --> I[Mount Filesystems];
    H --> I;
    I --> J[Pacstrap Base System];
    J --> K[Install GRUB Bootloader];
    K --> L[Configure System: Timezone, Locale, Hostname];
    L --> M[Create User & Set Password];
    M --> N[Install User SSH Key];
    N --> O[Generate fstab];
    O --> P[Chroot & Finalize GRUB];
    P --> Q[Unmount & Reboot];
    Q --> R[End: Arch Linux Installed];
```

## Requirements

-   Ansible version: `2.9+` (or as per `ansible-ctrl.dockerfile`)
-   Target Host: Must be booted into the Arch Linux installation environment.
-   SSH Access: SSH server must be running on the target Arch ISO environment, and accessible by Ansible (typically as the `root` user initially).
-   Environment Variables: Certain sensitive variables (passwords) are expected to be set as environment variables on the Ansible controller (see `defaults/main.yml` and "Role Variables" section).
-   Internet Access: Required on the target host to download packages during the Arch Linux installation.

## Role Variables

Variables are defined in `defaults/main.yml`. Sensitive values like passwords should be supplied via environment variables on the Ansible controller.

| Variable                      | Default Value                                  | Description                                                                                                |
| ----------------------------- | ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `install_drive`               | `/dev/sda`                                     | The target disk device for Arch Linux installation (e.g., `/dev/vda`, `/dev/nvme0n1`). **Verify this carefully!** |
| `encryption.enabled`          | `true`                                         | Enables LUKS encryption for the root partition.                                                            |
| `encryption.password`         | `"{{ lookup('env', 'ENCRYPTION_PASSWORD') }}"` | The password for LUKS encryption. **Must be set as an environment variable `ENCRYPTION_PASSWORD`**.         |
| `btrfs.enabled`               | `true`                                         | If `true`, uses BTRFS for the root filesystem. If `false`, ext4 will be used.                               |
| `btrfs.subvols`               | (See `defaults/main.yml`)                      | A list of BTRFS subvolumes to create. Each item is a dictionary with `sub`, `path`, and optional `disable_cow`. |
| `timezone`                    | `America/Chicago`                              | The system timezone to set (e.g., `Europe/London`, `UTC`).                                                   |
| `user.name`                   | `on3ir`                                        | The username for the primary user to be created.                                                           |
| `user.password`               | `"{{ lookup('env', 'USER_PASSWORD') }}"`       | The password for the primary user. **Must be set as an environment variable `USER_PASSWORD`**.             |
| `user.full`                   | `on3iropolos`                                  | The full name (GECOS) for the primary user.                                                                |
| `user.email`                  | `on3iropolos@gmail.com`                        | The email address for the primary user (used for git config, etc.).                                        |
| `user.pub_key_location`       | `/root/.ssh/on3iropolos-ssh.pub`               | Path on the Ansible controller to the user's public SSH key, to be installed for the new user on the target. |
| `bootloader`                  | `grub`                                         | The bootloader to install. Currently, only GRUB is supported.                                              |
| `boot_esp`                    | `/boot/efi`                                    | The mount point for the EFI System Partition (ESP).                                                        |

*(For the structure of `btrfs.subvols`, refer to `roles/arch-iso-install/defaults/main.yml`.)*

## Dependencies

None. This role is self-contained for the installation process.

## Example Playbook

This role is typically run against a host that is booted into the Arch Linux installation media. The `ansible_user` is usually `root` for the installation process.

```yaml
- hosts: archiso_target_host  # A host defined in your inventory, booted into Arch ISO
  become: true
  ansible_user: root          # Or the user accessible in the Arch ISO environment
  environment:                # Ensure these are set on the controller
    ENCRYPTION_PASSWORD: "your_strong_encryption_password"
    USER_PASSWORD: "your_strong_user_password"
  roles:
    - role: arch-iso-install
      vars:
        install_drive: /dev/vda  # Example: Overriding the default install drive
        user.name: "newadmin"
        user.pub_key_location: "/path/to/newadmin.pub" # Path on Ansible controller
        timezone: "Europe/Berlin"
```

**Important:** Ensure environment variables `ENCRYPTION_PASSWORD` and `USER_PASSWORD` are set in the shell where you run `ansible-playbook`, or through other secure means like Ansible Tower/AWX credentials.

## License

See the `LICENSE` file within this role's directory (`roles/arch-iso-install/LICENSE`).

## Author Information

Gnome Network Ansible project (adapted from original sources)
```
