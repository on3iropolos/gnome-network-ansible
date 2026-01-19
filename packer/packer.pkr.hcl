packer {
  required_plugins {
    hyperv = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/hyperv"
    }
    ansible = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "iso_url" {
  type    = string
  default = "https://geo.mirror.pkgbuild.com/iso/2026.01.01/archlinux-2026.01.01-x86_64.iso"
}

variable "iso_checksum" {
  type    = string
  default = "file:https://geo.mirror.pkgbuild.com/iso/2026.01.01/sha256sums.txt"
}

variable "ssh_password" {
  type      = string
  sensitive = true
  # Value provided in secrets.auto.pkrvars.hcl
}

variable "encryption_password" {
  type      = string
  sensitive = true
  # Value provided in secrets.auto.pkrvars.hcl
}

variable "user_password" {
  type      = string
  sensitive = true
  # Value provided in secrets.auto.pkrvars.hcl
}

variable "user_ssh_key" {
  type      = string
  sensitive = true
  # Value provided in secrets.auto.pkrvars.hcl
}

source "hyperv-iso" "archlinux" {
  iso_url           = var.iso_url
  iso_checksum      = var.iso_checksum
  shutdown_command  = "shutdown -P now"
  disk_size         = "20000"
  vm_name           = "archlinux-image"
  memory            = 8192
  cpus              = 2
  generation        = 2
  switch_name       = "Default Switch"
  boot_wait         = "30s"
  boot_command      = [
    "<enter><wait5s>",
    "curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/install.sh<enter><wait>",
    "bash install.sh /dev/sda '${var.ssh_password}'<enter>"
  ]
  http_directory    = "http"
  ssh_username      = "root"
  ssh_password      = var.ssh_password
  ssh_timeout       = "20m"
}

build {
  sources = ["source.hyperv-iso.archlinux"]

  # 1. Install Arch Linux (Partitioning, Base System, etc.)
  # Runs from the host against the Live ISO (which was bootstrapped by install.sh)
  # 1. Install Arch Linux (Partitioning, Base System, etc.)
  # Runs inside the Live ISO environment
  provisioner "shell" {
    inline = ["mkdir -p /root/ansible"]
  }

  provisioner "file" {
    source      = "../packer_install.yml"
    destination = "/root/ansible/packer_install.yml"
  }

  provisioner "file" {
    source      = "../roles"
    destination = "/root/ansible/roles"
  }

  provisioner "shell" {
    environment_vars = [
      "ENCRYPTION_PASSWORD=${var.encryption_password}",
      "USER_PASSWORD=${var.user_password}",
      "USER_SSH_KEY=${var.user_ssh_key}",
      "ANSIBLE_FORCE_COLOR=1"
    ]
    inline = [
      "mount -o remount,size=5G /run/archiso/cowspace",
      "pacman -Syu --noconfirm --ignore linux ansible python-passlib",
      "cd /root/ansible",
      "ansible-playbook packer_install.yml -i localhost, -c local -vvv > /tmp/ansible_install.log 2>&1 || (cat /tmp/ansible_install.log && exit 1)"
    ]
  }

  # 2. Upload Roles and Inventory for Post-Install Configuration
  provisioner "shell" {
    inline = ["mkdir -p /mnt/root/ansible"]
  }

  provisioner "file" {
    source      = "../roles"
    destination = "/mnt/root/ansible/roles"
  }

  provisioner "file" {
    source      = "../inventories"
    destination = "/mnt/root/ansible/inventories"
  }

  provisioner "file" {
    source      = "../packer_provision.yml"
    destination = "/mnt/root/ansible/packer_provision.yml"
  }

  # 3. Configure the Installed System (GNOME, Network, etc.)
  # Runs inside the new system via arch-chroot
  provisioner "shell" {
    environment_vars = [
      "USER_PASSWORD=${var.user_password}",
      "USER_SSH_KEY=${var.user_ssh_key}",
      "ANSIBLE_FORCE_COLOR=1"
    ]
    inline = [
      "arch-chroot /mnt ansible-playbook /root/ansible/packer_provision.yml -i localhost, -c local -vvv --extra-vars '@/root/ansible/inventories/workstations/host_vars/whimsyforge.gnome.network.yml'",
      "rm -rf /mnt/root/ansible"
    ]
  }

  # 4. Cleanup and Security
  provisioner "shell" {
    inline = [
      "# Disable root login on the installed system",
      "sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /mnt/etc/ssh/sshd_config"
    ]
  }
}
