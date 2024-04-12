# Role: arch-iso-install

This role is to install Arch Linux after booting from the installation media. It includes the following features:

    - Partition Encryption
    - BTRFS filesystem (or ext4)
    - GRUB bootloader

Take note of the variables in the `defaults` directory.

Special thanks to the following repos:

    - https://github.com/33Fraise33/desktop-ansible/tree/main
    - https://github.com/jsf9k/ansible-arch-install
