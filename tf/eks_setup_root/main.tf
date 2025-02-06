data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "my-terraform-state-vpc"
    key    = "vpc/terraform.tfstate"
    region = "eu-north-1"
  }
}

module "eks" {
  source             = "../modules/eks_cluster/eks"
  name               = var.name
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
}

module "node_groups" {
  source             = "../modules/eks_cluster/node_group"
  name               = var.name
  cluster_name       = module.eks.cluster_name
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
}

module "ebs_csi_driver" {
  source        = "../modules/eks_cluster/ebs_csi_driver"
  cluster_name  = module.eks.cluster_name
  region        = "eu-north-1"
}

module "secrets" {
  source        = "../modules/secrets"
  cluster_name  = module.eks.cluster_name
  region        = "eu-north-1"
}
