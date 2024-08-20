#module "pve_cfg_a" {
#  source = "./modules/proxmox_config"
#
## Input variables
#  environment = "dev"
#  instance = "a"
#  bridge = "vmbr2"
#}

#module "pve_cfg_b" {
#  source = "./modules/proxmox_config"
#
## Input variables
#  environment = "dev"
#  instance = "b"
#  bridge = "vmbr2"
#}

#resource "proxmox_lxc" "k3s_master" {
#  target_node = "pve"
#  hostname = "k3s-master"
## ID of container to clone
#  clone = "115"
#  
#  rootfs {
#    storage = "poolboy"
#    size    = "8G"
#  }
#  start = "true"
#}
