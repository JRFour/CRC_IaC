resource "proxmox_lxc" "ct_instance" {
  target_node  = "${var.node}"
  hostname     = "${var.environment}-ct"
  ostemplate   = "local:vztmpl/${var.os}" 
  password     = "${var.password}"
  unprivileged = true
  onboot       = true
  start	       = true

# Terraform will crash without rootfs defined
  rootfs {
    storage = "${var.storage}"
    size    = "${var.storage_size}"
  }

  network {
    name   = "eth0"
    bridge = var.bridge
    ip     = "dhcp"
  }

}

#resource "proxmox_vm_qemu" "basic_kali" {
#  name        = "basickali"
#  target_node = "pve"
#  clone       = "Kali"
#}
