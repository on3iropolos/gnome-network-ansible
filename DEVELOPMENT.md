# Development Environment Setup for Ansible

This document outlines how to set up and use the Vagrant environment for Ansible development, which includes two Arch Linux virtual machines.

## Important Notes

- The [`Vagrantfile`](Vagrantfile) uses the `generic/arch` box (version 4.3.12) as the official `archlinux/archlinux` box has compatibility issues with the libvirt provider.
- The base Arch Linux VMs do not include Python by default. Most Ansible modules require Python on target hosts. You can use the `raw` module for initial bootstrapping to install Python, or install it manually via SSH before running standard Ansible playbooks.

## Prerequisites

1.  **Install Vagrant**:
    Follow the official installation instructions for your operating system:
    [https://www.vagrantup.com/docs/installation](https://www.vagrantup.com/docs/installation)

2.  **Install a Virtualization Provider**:
    Vagrant requires a virtualization provider to run the VMs. Popular choices are:
    *   **libvirt (Default configuration, recommended for Linux users preferring KVM)**:
        Installation varies by distribution. For example, on Ubuntu/Debian:
        ```bash
        sudo apt update
        sudo apt install libvirt-daemon-system libvirt-clients qemu-kvm
        ```
        You will also need the `vagrant-libvirt` plugin:
        ```bash
        vagrant plugin install vagrant-libvirt
        ```
        Ensure your user is part of the `libvirt` and `kvm` groups:
        ```bash
        sudo usermod -aG libvirt $(whoami)
        sudo usermod -aG kvm $(whoami)
        # Log out and log back in for group changes to take effect.
        ```
    *   **VirtualBox (Cross-platform compatibility)**:
        Download and install from [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
        **Note**: The current [`Vagrantfile`](Vagrantfile) has VirtualBox configuration commented out. To use VirtualBox, uncomment the VirtualBox provider section and comment out the libvirt section in the Vagrantfile.

## Managing the Virtual Machines

All commands should be run in the same directory as the `Vagrantfile`.

### 1. Bringing Up the VMs

To create and start the virtual machines, run:

```bash
vagrant up
```

This command will download the Arch Linux base box if it's not already present, then configure and boot the two VMs: `arch-test-1` and `arch-test-2`.

### 2. Accessing the VMs via SSH

Vagrant simplifies SSH access.

*   To SSH into `arch-test-1`:
    ```bash
    vagrant ssh arch-test-1
    ```
*   To SSH into `arch-test-2`:
    ```bash
    vagrant ssh arch-test-2
    ```

You will be logged in as the `vagrant` user, which has passwordless sudo privileges.

### 3. Using with Ansible

To use these VMs as target hosts for Ansible playbooks run from your **host machine**:

*   **Get SSH Configuration**:
    Vagrant can generate an SSH configuration snippet that you can use with Ansible. Run:
    ```bash
    vagrant ssh-config
    ```
    This will output something like:
    ```
    Host arch-test-1
      HostName 192.168.121.242
      User vagrant
      Port 22
      UserKnownHostsFile /dev/null
      StrictHostKeyChecking no
      PasswordAuthentication no
      IdentityFile /path/to/your/project/.vagrant/machines/arch-test-1/libvirt/private_key
      IdentitiesOnly yes
      LogLevel FATAL
      PubkeyAcceptedKeyTypes +ssh-rsa
      HostKeyAlgorithms +ssh-rsa

    Host arch-test-2
      HostName 192.168.121.165
      User vagrant
      Port 22
      UserKnownHostsFile /dev/null
      StrictHostKeyChecking no
      PasswordAuthentication no
      IdentityFile /path/to/your/project/.vagrant/machines/arch-test-2/libvirt/private_key
      IdentitiesOnly yes
      LogLevel FATAL
      PubkeyAcceptedKeyTypes +ssh-rsa
      HostKeyAlgorithms +ssh-rsa
    ```
    *(Note: With libvirt, VMs get direct IP addresses on a virtual network (e.g., 192.168.121.x). `HostName` IPs will vary each time VMs are created. The provider directory name in `IdentityFile` will be `libvirt` by default, or `virtualbox` if using VirtualBox provider.).*

*   **Ansible Inventory**:
    You can create an Ansible inventory file (e.g., `inventory.ini`) using this information. For example:

    ```ini
    [arch_vms]
    arch-test-1.gnome.network ansible_host=192.168.121.242 ansible_port=22 ansible_user=vagrant ansible_private_key_file=./.vagrant/machines/arch-test-1/libvirt/private_key
    arch-test-2.gnome.network ansible_host=192.168.121.165 ansible_port=22 ansible_user=vagrant ansible_private_key_file=./.vagrant/machines/arch-test-2/libvirt/private_key

    [all:vars]
    ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
    ```
    **Important**:
    *   Use relative paths (starting with `./`) for the `ansible_private_key_file` to work correctly in both host and Docker container environments.
    *   Replace the `ansible_host` IP addresses with the actual IPs from `vagrant ssh-config` output, as they may differ.
    *   The hostnames `arch-test-1.gnome.network` and `arch-test-2.gnome.network` are used as aliases in the inventory. Ansible will connect to the `ansible_host` and `ansible_port` specified.
    *   The `ansible_ssh_common_args` helps bypass host key checking for these development VMs.
    *   **Python requirement**: Most Ansible modules require Python on target hosts. The base VMs don't include Python - see the Troubleshooting section for installation instructions.

*   **Running Ansible Playbooks**:
    Once your inventory is set up, you can run playbooks:
    ```bash
    ansible-playbook -i inventory.ini your_playbook.yml
    ```

### 4. Checking VM Status

To see the status of your Vagrant managed machines:

```bash
vagrant status
```

### 5. Suspending VMs

To save the current state of the VMs and stop them (like hibernation):

```bash
vagrant suspend
```
To resume:
```bash
vagrant resume
```

### 6. Halting VMs

To shut down the VMs gracefully:

```bash
vagrant halt arch-test-1
vagrant halt arch-test-2
# Or halt all VMs managed by the Vagrantfile
vagrant halt
```

### 7. Destroying VMs

To remove the VMs and all associated resources (disk images, etc.):

```bash
vagrant destroy arch-test-1
vagrant destroy arch-test-2
# Or destroy all VMs managed by the Vagrantfile
vagrant destroy -f # -f forces without confirmation
```
**Warning**: This is destructive and will delete the VMs. You'll need to run `vagrant up` again to recreate them.

## Known Issues

*   **fog Warning about `libvirt_ip_command`**: You may see warnings like `[fog][WARNING] Unrecognized arguments: libvirt_ip_command` when using Vagrant commands. This is a known compatibility issue between vagrant-libvirt 0.12.2 and fog-libvirt, where vagrant-libvirt passes a parameter that fog-libvirt doesn't recognize. **This warning is harmless and can be safely ignored** - it does not affect the functionality of your VMs or Vagrant operations.

## Troubleshooting

*   **Python Installation**: The `generic/arch` box does not include Python by default. To use most Ansible modules, you need to install Python on the target VMs. You can do this by:
    1. SSH into each VM: `vagrant ssh arch-test-1` then `sudo pacman -S python`
    2. Or use Ansible's `raw` module to bootstrap: `ansible all -i inventory.ini -m raw -a "sudo pacman -Sy --noconfirm python"`
*   **Arch Linux Box Updates**: The `generic/arch` box is a rolling release. After `vagrant up`, it's a good idea to update the package database and upgrade packages within the VMs:
    ```bash
    vagrant ssh arch-test-1 -c "sudo pacman -Syu --noconfirm"
    vagrant ssh arch-test-2 -c "sudo pacman -Syu --noconfirm"
    ```
*   **Provider Issues**: If you encounter issues with VirtualBox or libvirt, ensure they are correctly installed and configured, and that your user has the necessary permissions. Check the Vagrant output for specific error messages.
*   **Plugin Conflicts**: If you have many Vagrant plugins, sometimes they can conflict. Try disabling non-essential plugins if you face unexpected behavior.

This setup provides a consistent and reproducible environment for your Ansible development and testing.
