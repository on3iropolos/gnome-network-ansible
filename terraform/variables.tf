# Variable definitions for Terraform VM testing

variable "pool_name" {
  description = "libvirt storage pool name"
  type        = string
  default     = "default"
}

variable "arch_iso_url" {
  description = "URL or local path to Arch Linux ISO"
  type        = string
  default     = "https://mirror.rackspace.com/archlinux/iso/latest/archlinux-x86_64.iso"
}

variable "memory_mb" {
  description = "Memory allocation in MB"
  type        = number
  default     = 2048
}

variable "vcpus" {
  description = "Number of virtual CPUs"
  type        = number
  default     = 2
}

variable "disk_size_bytes" {
  description = "Installation disk size in bytes (default: 5GB)"
  type        = number
  default     = 5368709120
}