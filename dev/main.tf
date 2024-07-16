module "pve_cfg_a" {
  source = "../modules/proxmox_config"

# Input variables
  environment = "dev"
  instance = "a"
  bridge = "vmbr2"
}

module "pve_cfg_b" {
  source = "../modules/proxmox_config"

# Input variables
  environment = "dev"
  instance = "b"
  bridge = "vmbr2"
}
