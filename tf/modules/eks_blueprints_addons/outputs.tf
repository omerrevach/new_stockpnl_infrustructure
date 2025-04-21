output "alb_hostname" {
  description = "ALB hostname from ingress if available"
  value = null # Return null to avoid dependency errors
}

output "aws_load_balancer_controller" {
  description = "The AWS Load Balancer Controller addon"
  value = try(module.eks_blueprints_addons.aws_load_balancer_controller, null)
}

output "external_secrets" {
  description = "The External Secrets addon"
  value = try(module.eks_blueprints_addons.external_secrets, null) 
}

output "argocd" {
  description = "The ArgoCD addon"
  value = try(module.eks_blueprints_addons.argocd, null)
}