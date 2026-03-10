terraform {
  backend "s3" {
    bucket = "00terrstate"
    key = "web_terraform.tfstate"
    region = "us-east-1"
  }
}
