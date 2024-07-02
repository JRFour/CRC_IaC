module "proxmox_config" {
  source = "../modules/proxmox_config"

# Input variables
  environment = "dev"
  PM_API_TOKEN_ID = var.PM_TOKEN_ID
}
