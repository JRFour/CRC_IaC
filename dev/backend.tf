terraform {
  backend "s3" {
    bucket = "00terrstate"
    key = "terrraform.tfstate"
    region = "us-east-1"
  }
}
