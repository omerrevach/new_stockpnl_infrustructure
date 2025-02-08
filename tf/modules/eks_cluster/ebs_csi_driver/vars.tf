variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN for IRSA"
  type        = string
}

variable "eks_cluster_endpoint" {
  description = "EKS Cluster API Endpoint"
  type        = string
}

variable "eks_cluster_token" {
  description = "EKS Cluster Authentication Token"
  type        = string
}

variable "eks_cluster_ca" {
  description = "EKS Cluster CA Certificate"
  type        = string
}
