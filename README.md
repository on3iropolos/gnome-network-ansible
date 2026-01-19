# Gnome Network Ansible

A high-performance, purist automation suite for Arch Linux. This repository facilitates both reproducible **VM Image Building** (via Packer) and **Bare Metal Deployment** (via Ansible) for workstations.

## 🚀 Key Features
- **Stateless Installation**: Uses a modular "Storage Stack" (Partition -> Encryption -> Filesystem).
- **Environment Parity**: The same Ansible roles drive both Packer VM builds and local workstation installs.
- **Security First**: Integrated LUKS encryption support and SSH hardening.
- **Desktop Ready**: Automated GNOME environment provisioning with Bitwarden and Antigravity AI IDE.

---

## 🏗️ Architecture

The automation is split into two distinct phases to ensure maximum reliability and separation of concerns:

1.  **Phase 1: Installation (`install.yml`)**
    - Targets the **Arch Live ISO** environment.
    - Handles disk partitioning, LUKS encryption, and BTRFS subvolumes.
    - Installs the base system via `pacstrap`.
    - Configures the bootloader and core networking.
    - Operates on the target disk mounted at `/mnt`.

2.  **Phase 2: Provisioning (`provision.yml`)**
    - Targets the **Installed OS**.
    - Configures user accounts, GNOME shell, desktop applications (Bitwarden, Antigravity), and system services.
    - Can be run inside `arch-chroot` (during build) or against a live booted system.

---

## 📦 Usage: Packer (VM Images)

Packer is used to generate a pre-configured VHDX for Hyper-V.

### 1. Initialize & Build
```bash
cd packer
packer init .
packer build .
```

### 2. How it works
- **Bootstrap**: Boots the Arch ISO and runs a minimal `install.sh` to enable SSH.
- **Local Execution**: Packer uploads this entire repository to the Live ISO and runs Ansible **locally** inside the ISO to minimize network latency and host dependencies.
- **Chrooted Provisioning**: After installation, Packer runs the provisioning playbook inside an `arch-chroot` to finalize the image before shutdown.

---

## 💻 Usage: Local System (Bare Metal)

Deploy Arch Linux directly to your local hardware.

### 1. Prepare the Target
1.  Boot the [Arch Linux Live ISO](https://archlinux.org/download/) on your target machine.
2.  Connect to the internet (`iwctl` for Wi-Fi or plug in Ethernet).
3.  **Pre-Flight Verification**: Before proceeding, run these commands on the ISO to ensure your environment matches the configuration:
    - **Internet**: `ping -c 3 google.com`
    - **Drive Path**: `lsblk` (Identify your target drive, e.g., `/dev/nvme0n1`).
    - **Boot Mode**: `ls /sys/firmware/efi/efivars` (If this dir exists, you are in UEFI mode).
4.  **Bootstrap Environment**: Install Git and Ansible directly onto the Live ISO ramdisk. 
    > [!TIP]
    > If you encounter a "Partition / is too full" error, increase the cowspace size:
    > `mount -o remount,size=4G /run/archiso/cowspace`

    ```bash
    pacman -Syu --noconfirm git ansible
    ```
5.  **Clone the Repository**:
    ```bash
    git clone https://github.com/on3iropolos/gnome-network-ansible.git
    cd gnome-network-ansible
    ```

### 2. Run Installation
Execute the installation locally within the ISO. Use environment variables to pass your secrets and CLI flags to target the local machine.

```bash
# Set secrets
export USER_PASSWORD="YourUserPassword"
export ENCRYPTION_PASSWORD="YourLUKSPassword"
export USER_SSH_KEY="ssh-rsa AAAAB3Nza..."

# Run the installer locally
# -i: specifies the workstations inventory
# --limit: ensures we only target your host
# -c local: forces a local connection bypasses SSH
# -e: passes the install_drive variable (REQUIRED)
ansible-playbook install.yml \
  -i inventories/workstations \
  --limit whimsyforge.gnome.network \
  -e "install_drive=/dev/nvme0n1" \
  -c local
```

### 3. Run Provisioning (Post-Reboot)
Once the system reboots, log in as your new user, clone the repo again (or use the copy left in `/root/ansible` if you kept it), and run the provisioning playbook. 

Since the system is now live, we override `install_root` to target the root directory directly:
```bash
ansible-playbook provision.yml -e "install_root="
```

---

## 🔐 Configuration & Secrets

Variables are managed via Ansible's `group_vars` and `host_vars`. 

- **Global Config**: `inventories/workstations/group_vars/all.yml` (Drives, Usernames, etc).
- **Machine Specific**: `inventories/workstations/host_vars/whimsyforge.gnome.network.yml`.
- **Secret Management**: Passwords and keys are pulled from environment variables (`USER_PASSWORD`, `ENCRYPTION_PASSWORD`, `USER_SSH_KEY`) to keep them out of source control.

---

## 🛠️ Development

### Setup
Ensure you have the requirements installed:
```bash
pip install -r requirements.txt
make setup
```

### Formatting & Linting
We use `ansible-lint` and `pre-commit` to maintain code quality:
```bash
make lint
```
