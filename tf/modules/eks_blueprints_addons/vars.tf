variable "cluster_name" {
  type        = string
}

variable "cluster_endpoint" {
  type        = string
}

variable "cluster_version" {
  type        = string
}

variable "oidc_provider_arn" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "region" {
  type        = string
}

variable "acm_cert_id" {}

variable "check_ingress" {
  description = "to check for the frontend-ingress existence"
  type        = bool
  default     = false
}