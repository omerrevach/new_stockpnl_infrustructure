module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.15.1"

  cluster_name      = var.cluster_name
  cluster_endpoint  = var.cluster_endpoint
  cluster_version   = var.cluster_version
  oidc_provider_arn = var.oidc_provider_arn

  enable_argocd                       = true
  enable_aws_load_balancer_controller = true
  enable_external_secrets             = true

  aws_load_balancer_controller = {
    set = [
      {
        name  = "vpcId"
        value = var.vpc_id
      }
    ]
  }

  external_secrets = {
    set = [
      {
        name  = "region"
        value = var.region
      }
    ]
  }

  argocd = {
    namespace     = "argocd"
    chart_version = "5.29.1"
    repository    = "https://argoproj.github.io/argo-helm"
    values        = []
  }
}
