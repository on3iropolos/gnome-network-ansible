# Ansible vs System Configuration Analysis: stump

**Date:** 2026-03-18  
**System:** stump (localhost)  
**Playbook:** provision.yml

---

## Current System State (stump)

```
Hostname:           stump
User:               on3i (uid=1000, groups: on3i,sys,network,wheel,audio,lp,storage,video,users,rfkill,nopasswdlogin,greeter)
Shell:              /bin/fish
Timezone:           America/Chicago (CDT)
Locale:             en_US.UTF-8
Desktop Environment: COSMIC (niri compositor, wayland session)
```

### Services
| Service | Status | Enabled |
|---------|--------|---------|
| NetworkManager | running | enabled |
| sshd | inactive | disabled |
| docker | inactive | disabled |
| gdm | inactive | disabled |

### Installed Packages
**Present:** bitwarden, paru, base-devel, git  
**Missing:** docker, qemu-desktop, edk2-ovmf, gnome, gnome-extra, spotify, bitwarden-cli

---

## Potential Conflicts

### GNOME Role
- Installs GNOME desktop environment
- Would conflict with COSMIC/niri on stump
- **Status:** Already mitigated with `when: inventory_hostname == 'whimsyforge.gnome.network'`

### QEMU Role
- Installs QEMU with desktop UI
- Desktop machines may not need VM infrastructure
- **Status:** Already mitigated with `when: inventory_hostname == 'whimsyforge.gnome.network'`

### User Configuration
- User is "on3i" (not "user")
- Shell is fish (not bash)
- **Status:** Variables need to be set from vault

### SSH Client Role
- Configures ~/.ssh/config
- May conflict with existing SSH configuration
- **Status:** Template only generates Host entries, preserves existing config

### Docker Role
- Installs and enables Docker service
- May not be needed on desktop machines
- **Status:** Review if needed

### Spotify/AUR Role
- Requires aur_builder user
- Installs from AUR
- **Status:** Review if needed on all machines

---

## Recommendations

1. Add `when` conditions for aur/spotify roles (whimsyforge only)
2. Document vault.yml structure for multi-workstation
3. Test provisioning on both machines
