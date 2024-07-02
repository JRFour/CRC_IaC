provider "proxmox" {
  pm_api_url   = "https://pve.hogwarts.home:8006/api2/json"
  pm_tls_insecure = true
  pm_api_token_id = var.PM_API_TOKEN_ID
}

provider "aws" {
    region = "us-east-1"
}
