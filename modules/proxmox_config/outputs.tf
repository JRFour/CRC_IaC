output "proxmox_ct_ip" {
  description = "The IP of the container"
  value       = proxmox_lxc.ct_instance.id
}
