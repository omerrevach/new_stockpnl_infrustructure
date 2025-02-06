terraform {
  backend "s3" {
    bucket         = "my-terraform-state-vpc"
    key            = "vpc/terraform.tfstate"
    region         = "eu-north-1"
  }
}
