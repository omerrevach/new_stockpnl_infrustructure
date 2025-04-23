variable "name" {
  description = "Cluster name"
  type        = string
}

variable "hosted_zone_id" {
  description = "Hosted zone ID for Route53"
  type        = string
}

variable "app_domain_name" {
  description = "Domain name for the application"
  type        = string
}

variable "acm_cert_id" {
  description = "ACM certificate ID for HTTPS"
  type        = string
}
