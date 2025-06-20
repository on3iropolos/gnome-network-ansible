# Development Environment Setup for Ansible

This document outlines how to set up and use the Vagrant environment for Ansible development, which includes two Arch Linux virtual machines.

## Prerequisites

1.  **Install Vagrant**:
    Follow the official installation instructions for your operating system:
    [https://www.vagrantup.com/docs/installation](https://www.vagrantup.com/docs/installation)

2.  **Install a Virtualization Provider**:
    Vagrant requires a virtualization provider to run the VMs. Popular choices are:
    *   **VirtualBox (Recommended for cross-platform compatibility)**:
        Download and install from [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
    *   **libvirt (Recommended for Linux users preferring KVM)**:
        Installation varies by distribution. For example, on Ubuntu/Debian:
        ```bash
        sudo apt update
        sudo apt install libvirt-daemon-system libvirt-clients qemu-kvm
        ```
        You will also need the `vagrant-libvirt` plugin:
        ```bash
        vagrant plugin install vagrant-libvirt
        ```
        Ensure your user is part of the `libvirt` or `kvm` group:
        ```bash
        sudo usermod -aG libvirt $(whoami)
        sudo usermod -aG kvm $(whoami)
        # Log out and log back in for group changes to take effect.
        ```

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
      HostName 127.0.0.1
      User vagrant
      Port 2222
      UserKnownHostsFile /dev/null
      StrictHostKeyChecking no
      PasswordAuthentication no
      IdentityFile /path/to/your/project/.vagrant/machines/arch-test-1/virtualbox/private_key
      IdentitiesOnly yes
      LogLevel FATAL

    Host arch-test-2
      HostName 127.0.0.1
      User vagrant
      Port 2200
      UserKnownHostsFile /dev/null
      StrictHostKeyChecking no
      PasswordAuthentication no
      IdentityFile /path/to/your/project/.vagrant/machines/arch-test-2/virtualbox/private_key
      IdentitiesOnly yes
      LogLevel FATAL
    ```
    *(Note: `HostName` and `Port` will vary based on your setup and provider).*

*   **Ansible Inventory**:
    You can create an Ansible inventory file (e.g., `inventory.ini`) using this information. For example:

    ```ini
    [arch_vms]
    arch-test-1.gnome.network ansible_host=127.0.0.1 ansible_port=2222 ansible_user=vagrant ansible_private_key_file=/path/to/your/project/.vagrant/machines/arch-test-1/virtualbox/private_key
    arch-test-2.gnome.network ansible_host=127.0.0.1 ansible_port=2200 ansible_user=vagrant ansible_private_key_file=/path/to/your/project/.vagrant/machines/arch-test-2/virtualbox/private_key

    [all:vars]
    ansible_python_interpreter=/usr/bin/python3
    ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
    ```
    **Important**:
    *   Replace `/path/to/your/project/` with the actual absolute path to your project directory where the `Vagrantfile` is located.
    *   The hostnames `arch-test-1.gnome.network` and `arch-test-2.gnome.network` are used as aliases in the inventory. Ansible will connect to the `ansible_host` and `ansible_port` specified.
    *   The `ansible_ssh_common_args` helps bypass host key checking for these development VMs.

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

## Troubleshooting

*   **Arch Linux Box Updates**: The `archlinux/archlinux` box is a rolling release. After `vagrant up`, it's a good idea to update the package database and upgrade packages within the VMs:
    ```bash
    vagrant ssh arch-test-1 --command "sudo pacman -Syu --noconfirm"
    vagrant ssh arch-test-2 --command "sudo pacman -Syu --noconfirm"
    ```
*   **Provider Issues**: If you encounter issues with VirtualBox or libvirt, ensure they are correctly installed and configured, and that your user has the necessary permissions. Check the Vagrant output for specific error messages.
*   **Plugin Conflicts**: If you have many Vagrant plugins, sometimes they can conflict. Try disabling non-essential plugins if you face unexpected behavior.

This setup provides a consistent and reproducible environment for your Ansible development and testing.
