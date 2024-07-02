provider "proxmox" {
  pm_api_url   = "https://pve.hogwarts.home:8006/api2/json"
  pm_tls_insecure = true
}

provider "aws" {
    region = "us-east-1"
}
