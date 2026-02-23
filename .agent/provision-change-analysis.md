# Ansible Provision Playbook - Change Analysis

**Generated:** 2026-02-22  
**Target Host:** whimsyforge.gnome.network (192.168.50.100 - local connection)  
**Playbook:** provision.yml

---

## Current System State

| Component | Current Value |
|-----------|---------------|
| Hostname | whimsyforge |
| Timezone | America/Chicago |
| Locale | en_US.UTF-8 |
| User | on3i (uid=1000, groups: wheel, users, etc.) |
| SSH directory | /home/on3i/.ssh exists (mode 0755) |
| SSHD service | disabled |
| NetworkManager | enabled |
| GDM service | enabled |
| Bitwarden | 2025.10.0-1.1 installed |
| yay (AUR helper) | not installed |
| antigravity | not installed |
| Git global config | not set |

---

## Summary of Changes

Running `ansible-playbook provision.yml` will make the following changes:

| # | Role | Task | Change Type | Impact |
|---|------|------|-------------|--------|
| 1 | hosts | Set Hostname | Modify | Changes `/etc/hostname` from `whimsyforge` to `whimsyforge.gnome.network` |
| 2 | sshd | Enable SSHD | Service | Enables and starts `sshd` service |
| 3 | user | Create User | Create | Creates user `on3i` with groups `wheel` (if not exists) |
| 4 | user | Sudoers | Create | Creates `/etc/sudoers.d/wheel` with `%wheel ALL=(ALL) NOPASSWD: ALL` |
| 5 | user | SSH Directory | Modify | Changes `/home/on3i/.ssh` mode from `0755` to `0700` |
| 6 | user | Chown | Modify | Changes ownership of `/home/on3i/.ssh` to user `on3i` |
| 7 | ssh_client | Configure SSH Config | Modify | Updates `/home/on3i/.ssh/config` with github.com SSH config |
| 8 | git | Deploy Git Config | Create | Creates `/home/on3i/.gitconfig` with user name and email |
| 9 | gnome | Install GNOME | Package | Installs 180+ GNOME packages (gnome, gnome-extra) |
| 10 | gnome | Enable GDM | Service | Ensures GDM is enabled and started |
| 11 | bitwarden | Install Bitwarden | Package | Installs/updates bitwarden and bitwarden-cli |
| 12 | aur | Install AUR dependencies | Package | Installs `base-devel`, `git` and builds `yay-bin` from AUR |
| 13 | antigravity | Install Antigravity | Package | Installs `antigravity` from AUR using yay |

---

## Detailed Change Descriptions

### 1. hosts - Set Hostname

**File Modified:** `/etc/hostname`

| Before | After |
|--------|-------|
| whimsyforge | whimsyforge.gnome.network |

**Source:** `inventories/workstations/host_vars/whimsyforge.gnome.network.yml`

---

### 2. sshd - Enable SSHD

**Service:** `sshd`

| Before | After |
|--------|-------|
| disabled | enabled |

**Note:** This allows remote SSH connections to the machine.

---

### 3. user - Create User

**User:** `on3i`

The playbook uses the current user (`on3i`) which already exists on the system. However, the task will verify/update:
- User shell: `/bin/bash`
- User groups: `wheel` (primary), plus any additional groups from `user_groups` variable

**Note:** Since the user `on3i` already exists, this task will be skipped (no change).

---

### 4. user - Sudoers

**File Created:** `/etc/sudoers.d/wheel`

**Content:**
```
%wheel ALL=(ALL) NOPASSWD: ALL
```

**Purpose:** Allows members of the `wheel` group to run sudo commands without a password.

---

### 5. user - SSH Directory

**Directory:** `/home/on3i/.ssh`

| Before | After |
|--------|-------|
| mode: 0755 | mode: 0700 |

**Note:** The SSH directory should have restrictive permissions (0700) for security.

---

### 6. user - Chown

**Directory:** `/home/on3i/.ssh`

Changes ownership of the `.ssh` directory to ensure proper access:
- Owner: `on3i`
- Group: `on3i`
- Recursive: Yes

---

### 7. ssh_client - Configure SSH Config

**File Modified:** `/home/on3i/.ssh/config`

The playbook uses a template to generate the SSH config.

**Template:** `roles/ssh_client/templates/ssh_config.j2`

**Generated Content:**
```
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/on3iropolos-ssh
```

**Note:** This is already partially configured on the current system. The playbook will ensure the correct format and settings.

---

### 8. git - Deploy Git Config

**File Created:** `/home/on3i/.gitconfig`

**Content:**
```
[user]
  name = on3ir
  email = on3iropolos@gmail.com
```

**Source:** Variables from `inventories/workstations/group_vars/all.yml`:
- `git_user_name`: `on3ir` (default from env `GIT_USER_NAME` or fallback)
- `git_user_email`: `on3iropolos@gmail.com` (default from env `GIT_USER_EMAIL` or fallback)

**Note:** Currently no global git config exists. This will create one.

---

### 9. gnome - Install GNOME Desktop

**Packages Installed:** 180+ packages including:

**Core GNOME:**
- gnome-shell
- gnome-session
- gnome-settings-daemon
- gnome-control-center
- gnome-tweaks
- gnome-software

**GNOME Extra:**
- gnome-calculator
- gnome-calendar
- gnome-characters
- gnome-clocks
- gnome-contacts
- gnome-disk-utility
- gnome-font-viewer
- gnome-logs
- gnome-maps
- gnome-screenshot
- gnome-system-monitor
- gnome-text-editor
- gnome-weather
- gnome-boxes
- gnome-builder
- And many more...

**Note:** The current system already has GNOME installed (as indicated by GDM being enabled).

---

### 10. gnome - Enable GDM

**Service:** `gdm` (GNOME Display Manager)

| Before | After |
|--------|-------|
| enabled (already) | enabled + started |

**Note:** GDM is already enabled on the current system.

---

### 11. bitwarden - Install Bitwarden

**Packages:**
| Package | Current Version | New Version |
|---------|-----------------|-------------|
| bitwarden | 2025.10.0-1.1 | 2025.11.0-1.1 |
| bitwarden-cli | not installed | 2025.11.0-1.1 |
| argon2 | not installed | 20190702-6.3 |
| nodejs-lts-jod | not installed | 22.22.0-1 |
| semver | not installed | 7.7.4-1 |

**Note:** Bitwarden is already installed but may be updated. bitwarden-cli and dependencies will be newly installed.

---

### 12. aur - Install AUR Dependencies

**Packages Installed:**
- `base-devel` - Base development packages (already installed)
- `git` - Version control (already installed)
- `yay-bin` - AUR helper (built from source)

**Note:** The `yay` AUR helper is not currently installed. The playbook will build and install it.

---

### 13. antigravity - Install Antigravity

**Package:** `antigravity` (from AUR)

**Description:** AUR package for accessing the Antigravity network.

**Note:** Not currently installed. Will be installed using `yay`.

---

## Tasks That Will NOT Change (Already Correct)

| Role | Task | Current State |
|------|------|---------------|
| time | Set Timezone | America/Chicago (correct) |
| locale | Locale Conf | en_US.UTF-8 (correct) |
| locale | Keymap | Correct |
| network | Enable NetworkManager | enabled (correct) |
| gnome | Enable GDM | enabled (correct) |

---

## Pre-requisites for Running

1. **Passwordless sudo** - Already configured for user `on3i`
2. **Python** - Python 3.14 is installed
3. **Network access** - Required for installing packages from Pacman and AUR

---

## Dry-Run Command

To preview changes without applying:
```bash
ansible-playbook provision.yml --check --diff
```

## Apply Changes Command

To apply all changes:
```bash
ansible-playbook provision.yml
```
