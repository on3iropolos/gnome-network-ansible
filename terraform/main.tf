# Terraform configuration for creating test VMs
# Used for testing Ansible roles across the Gnome Network infrastructure

terraform {
  required_version = ">= 1.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "= 0.7.6"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Download and cache Arch Linux ISO
# Note: Don't specify format - let libvirt auto-detect to prevent re-downloads
resource "libvirt_volume" "arch_iso" {
  name   = "arch-iso.iso"
  pool   = var.pool_name
  source = var.arch_iso_url
}

# Create blank disk for installation
resource "libvirt_volume" "install_disk" {
  name   = "arch-install.qcow2"
  pool   = var.pool_name
  format = "qcow2"
  size   = var.disk_size_bytes
}

# Define the virtual machine
resource "libvirt_domain" "arch_test" {
  name   = "arch-test"
  memory = var.memory_mb
  vcpu   = var.vcpus

  cpu {
    mode = "host-passthrough"
  }

  boot_device {
    dev = ["cdrom", "hd"]
  }

  # ISO disk comes first (vda) for initial installation
  # After Ansible detaches it, hard disk (vdb) will be the only bootable device
  disk {
    volume_id = libvirt_volume.arch_iso.id
  }

  # Install disk comes second (vdb)
  disk {
    volume_id = libvirt_volume.install_disk.id
  }

  network_interface {
    network_name   = "default"
    mac            = "52:54:00:00:00:01" # Fixed MAC for DHCP reservation
    wait_for_lease = false                # Don't wait for IP during ISO boot
    hostname       = "arch-test"
  }

  # Add qemu-agent channel for better IP detection once OS is installed
  qemu_agent = false  # Not available during ISO boot, enable after OS install

  graphics {
    type           = "spice"
    listen_type    = "address"
    listen_address = "127.0.0.1"
    autoport       = true
  }

  video {
    type = "qxl"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
}