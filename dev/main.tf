module "pve_cfg_1" {
  source = "../modules/proxmox_config"

# Input variables
  environment = "dev"
  instance = "a"
  bridge = "vmbr2"
}

module "pve_cfg_2" {
  source = "../modules/proxmox_config"

# Input variables
  environment = "dev"
  instance = "b"
  bridge = "vmbr2"
}
