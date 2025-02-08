output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "cluster_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_ca" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.eks.token
}