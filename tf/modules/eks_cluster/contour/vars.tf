variable "eks_cluster_endpoint" {
  type = string
}

variable "eks_cluster_token" {
  type = string
}

variable "eks_cluster_ca" {
  type = string
}

variable "mod_dependency" {
  type        = any
  description = "Dependency variable to wait for AWS Load Balancer Controller to be ready"
  default     = null
}