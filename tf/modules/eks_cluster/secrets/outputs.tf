output "external_secrets_role_arn" {
  value       = aws_iam_role.external_secrets.arn
}

output "helm_release_name" {
  value       = helm_release.external_secrets.name
}

output "helm_release_namespace" {
  value       = helm_release.external_secrets.namespace
}