variable "cluster_name" {
  type        = string
}

variable "oidc_provider_arn" {
  type        = string
}

variable "eks_cluster_endpoint" {
  type        = string
}

variable "eks_cluster_token" {
  type        = string
}

variable "eks_cluster_ca" {
  type        = string
}

variable "vpc_id" {
  type        = string
}