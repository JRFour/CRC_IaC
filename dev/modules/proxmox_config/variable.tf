variable "node" {
  type = string
  description = "Name of the Proxmox node (default: pve)"
  default = "pve"
}

variable "environment" {
  type = string
  description = "dev, staging, or prod (default: dev)"
  default = "dev"
}

variable "instance" {
  type = string
  description = "Unique instance name suffix"
  default = "a"
}

variable "password" {
  type = string
  description = "Password for Proxmox CT (default: admin)"
  default = "admin"
}

variable "os" {
  type = string
  description = "OS for the Proxmox CT (default: ubuntu)"
  default = "ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
}

variable "bridge" {
  type = string
  description = "Bridge for the Proxmox CT (default: vmbr0)"
  default = "vmbr0"
}

variable "storage" {
  type = string
  description = "Storage Disk for Proxmox CT (default: poolboy)"
  default = "poolboy"
}

variable "storage_size" {
  type = string
  description = "Size of Proxmox CT Disk (default: 8G)"
  default = "8G"
}
