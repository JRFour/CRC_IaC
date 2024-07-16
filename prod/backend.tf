terraform {
  backend "s3" {
    bucket = "00terrstate"
    key = "web_terrraform.tfstate"
    region = "us-east-1"
  }
}
