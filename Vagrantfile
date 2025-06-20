# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Use a generic Arch Linux base box
  config.vm.box = "archlinux/archlinux"

  # Define the first virtual machine
  config.vm.define "arch-test-1" do |arch1|
    # You can add specific configurations for arch-test-1 here
    # For example, hostname:
    arch1.vm.hostname = "arch-test-1.gnome.network"
  end

  # Define the second virtual machine
  config.vm.define "arch-test-2" do |arch2|
    # You can add specific configurations for arch-test-2 here
    # For example, hostname:
    arch2.vm.hostname = "arch-test-2.gnome.network"

    # Example of port forwarding (if needed, uncomment and adjust)
    # arch2.vm.network "forwarded_port", guest: 80, host: 8080
  end

  # Provider-specific configuration (e.g., VirtualBox)
  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VMs:
    vb.memory = "1024"
    # Customize the number of CPUs:
    vb.cpus = "1"
  end

  # Provider-specific configuration (e.g., libvirt)
  # Make sure you have the vagrant-libvirt plugin installed:
  # vagrant plugin install vagrant-libvirt
  # config.vm.provider "libvirt" do |libvirt|
  #   # Customize the amount of memory on the VMs:
  #   libvirt.memory = 1024
  #   # Customize the number of CPUs:
  #   libvirt.cpus = 1
  # end

  # Provisioning with Ansible (optional, if you want Vagrant to run Ansible)
  # You would typically run Ansible from your host machine against these VMs,
  # but Vagrant can also orchestrate this.
  # config.vm.provision "ansible" do |ansible|
  #   ansible.playbook = "playbook.yml" # Path to your Ansible playbook
  #   # Ensure you have an inventory file that Vagrant can use or generate.
  #   # Vagrant can auto-generate an inventory.
  #   # ansible.inventory_path = "inventory/hosts"
  # end
end
