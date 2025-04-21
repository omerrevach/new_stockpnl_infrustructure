variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider for the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where EKS is deployed"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "check_ingress" {
  description = "Whether to check for the frontend-ingress existence"
  type        = bool
  default     = false
}