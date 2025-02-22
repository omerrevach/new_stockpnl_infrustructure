variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "oidc_provider_arn" {
  type        = string
  description = "ARN of the OIDC Provider"
}

variable "eks_cluster_endpoint" {
  type        = string
  description = "EKS cluster endpoint"
}

variable "eks_cluster_token" {
  type        = string
  description = "EKS cluster token"
}

variable "eks_cluster_ca" {
  type        = string
  description = "EKS cluster CA certificate"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}