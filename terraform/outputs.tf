# Output values for VM information

output "vm_name" {
  description = "Name of the created VM"
  value       = libvirt_domain.arch_test.name
}

output "vm_id" {
  description = "ID of the created VM"
  value       = libvirt_domain.arch_test.id
}

output "vm_ip" {
  description = "IP address assigned to the VM (may take a moment to appear)"
  value       = try(libvirt_domain.arch_test.network_interface[0].addresses[0], "Waiting for DHCP...")
}

output "install_disk" {
  description = "Installation target disk path in VM"
  value       = "/dev/vdb"
}

output "virt_viewer_command" {
  description = "Command to open graphical console with virt-viewer"
  value       = "virt-viewer --connect qemu:///system ${libvirt_domain.arch_test.name}"
}

output "virsh_console_command" {
  description = "Command to connect via virsh console"
  value       = "virsh --connect qemu:///system console ${libvirt_domain.arch_test.name}"
}

output "connection_info" {
  description = "All connection information"
  value = {
    vm_name    = libvirt_domain.arch_test.name
    vm_ip      = try(libvirt_domain.arch_test.network_interface[0].addresses[0], "Waiting for DHCP...")
    gui_access = "virt-viewer --connect qemu:///system ${libvirt_domain.arch_test.name}"
    ssh_ready  = "Wait for VM to boot, then: ssh root@<IP>"
  }
}