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

# Download Arch ISO (auto-detect format to prevent re-downloads)
resource "libvirt_volume" "arch_iso" {
  name   = "arch-iso.iso"
  pool   = var.pool_name
  source = var.arch_iso_url
}

resource "libvirt_volume" "install_disk" {
  name   = "arch-install.qcow2"
  pool   = var.pool_name
  format = "qcow2"
  size   = var.disk_size_bytes
}

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

  # ISO (vda) boots first; after Ansible detaches it, disk (vdb) takes over
  disk {
    volume_id = libvirt_volume.arch_iso.id
  }

  disk {
    volume_id = libvirt_volume.install_disk.id
  }

  network_interface {
    network_name   = "default"
    mac            = "52:54:00:00:00:01" # Fixed MAC for DHCP reservation
    wait_for_lease = false
    hostname       = "arch-test"
  }

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