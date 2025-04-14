data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "my-terraform-state-vpc"
    key    = "vpc/terraform.tfstate"
    region = "eu-north-1"
  }
}

module "eks" {
  source             = "../modules/eks"
  cluster_name       = var.name
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnets    = data.terraform_remote_state.vpc.outputs.private_subnets
}

module "eks_blueprints_addons" {
  source             = "../modules/eks_blueprints_addons"
  cluster_name       = module.eks.cluster_name
  cluster_endpoint   = module.eks.cluster_endpoint
  cluster_version    = module.eks.cluster_version
  oidc_provider_arn  = module.eks.oidc_provider_arn
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  region             = "eu-north-1"
  
  depends_on = [ module.eks ]
}

resource "time_sleep" "wait_for_lb_controller" {
  depends_on = [module.eks_blueprints_addons]
  create_duration = "30s"
}

resource "kubectl_manifest" "cluster_secret_store" {
  yaml_body = <<-YAML
    apiVersion: external-secrets.io/v1beta1
    kind: ClusterSecretStore
    metadata:
      name: global-secret-store
    spec:
      provider:
        aws:
          service: SecretsManager
          region: "eu-north-1"
          auth:
            jwt:
              serviceAccountRef:
                name: external-secrets-sa
                namespace: external-secrets
  YAML

  depends_on = [time_sleep.wait_for_lb_controller]
}
