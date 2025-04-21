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

resource "time_sleep" "wait_for_eks" {
  depends_on = [module.eks]
  create_duration = "30s"
}

module "eks_blueprints_addons" {
  source             = "../modules/eks_blueprints_addons"
  cluster_name       = module.eks.cluster_name
  cluster_endpoint   = module.eks.cluster_endpoint
  cluster_version    = module.eks.cluster_version
  oidc_provider_arn  = module.eks.oidc_provider_arn
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  region             = "eu-north-1"
  
  depends_on = [time_sleep.wait_for_eks]
}

# add a longer wait after the addons are installed
resource "time_sleep" "wait_for_addons" {
  depends_on = [module.eks_blueprints_addons]
  create_duration = "120s"  # time for the webhook to register
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

  depends_on = [time_sleep.wait_for_addons]
}

resource "kubernetes_manifest" "argocd_apps" {
  for_each = {
    auth     = "auth-service/helm"
    trade    = "trade_service/helm"
    frontend = "frontend/helm"
  }

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "app-${each.key}"
      namespace = "argocd"
    }
    spec = {
      project = "default"

      source = {
        repoURL        = "https://github.com/omerrevach/stockpnl_manifests_test.git"
        targetRevision = "main"
        path           = each.value
      }

      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "default"
      }

      syncPolicy = {
        automated = {
          prune     = true
          selfHeal  = true
        }
        syncOptions = [
          "CreateNamespace=true",
          "ApplyOutOfSyncOnly=true",
          "RespectIgnoreDifferences=true"
        ]
      }

      ignoreDifferences = [{
        group = "apps"
        kind  = "Deployment"
        jsonPointers = ["/spec/template/spec/containers/0/image"]
      }]
    }
  }

  depends_on = [
    module.eks_blueprints_addons,         # makes sure argocd deployed
    time_sleep.wait_for_addons,           # that alb is ready
    kubectl_manifest.cluster_secret_store # makes sure secrets is ready just in case
  ]
}
