data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "my-terraform-state-vpc"
    key    = "vpc/terraform.tfstate"
    region = "eu-north-1"
  }
}

data "aws_caller_identity" "current" {}

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
  source               = "../modules/eks_cluster/ebs_csi_driver"
  cluster_name         = module.eks.cluster_name
  oidc_provider_arn    = module.eks.cluster_oidc_provider_arn
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_cluster_token    = module.eks.cluster_token
  eks_cluster_ca       = module.eks.cluster_ca
}

module "aws_lb_controller" {
  source               = "../modules/eks_cluster/aws_lb_controller"
  cluster_name         = module.eks.cluster_name
  oidc_provider_arn    = module.eks.cluster_oidc_provider_arn
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_cluster_token    = module.eks.cluster_token
  eks_cluster_ca       = module.eks.cluster_ca
  vpc_id               = data.terraform_remote_state.vpc.outputs.vpc_id
}

module "contour" {
  source               = "../modules/eks_cluster/contour"
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_cluster_token    = module.eks.cluster_token
  eks_cluster_ca       = module.eks.cluster_ca
}

module "secrets" {
  source               = "../modules/eks_cluster/secrets"
  name                 = var.name
  cluster_name         = module.eks.cluster_name
  oidc_provider_arn    = module.eks.cluster_oidc_provider_arn
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_cluster_token    = module.eks.cluster_token
  eks_cluster_ca       = module.eks.cluster_ca
  region               = "eu-north-1"
}
