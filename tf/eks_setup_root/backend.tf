terraform {
  backend "s3" {
    bucket         = "my-terraform-state-vpc"
    key            = "eks/terraform.tfstate"
    region         = "eu-north-1"
  }
}