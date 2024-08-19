#output "pve_cfg_a_hostname" {
#  value = module.pve_cfg_a.container_name
#}

#output "pve_cfg_b_hostname" {
#  value = module.pve_cfg_b.container_name
#}

output "pve_k3s_master_hostname" {
  value = resource.proxmox_lxc.k3s_master
}
