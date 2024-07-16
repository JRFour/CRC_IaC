#output "proxmox_ct_ip" {
#  description = "The IP of the container"
#  value       = proxmox_lxc.ct_instance.id
#}
output "container_name" {
  description = "Hostname of container"
  value       = proxmox_lxc.ct_instance.hostname
}
