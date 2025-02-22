output "external_secrets_role_arn" {
  description = "ARN of the IAM role used by External Secrets"
  value       = aws_iam_role.external_secrets.arn
}

output "helm_release_name" {
  description = "Name of the External Secrets Helm release"
  value       = helm_release.external_secrets.name
}

output "helm_release_namespace" {
  description = "Namespace where External Secrets is installed"
  value       = helm_release.external_secrets.namespace
}