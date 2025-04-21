
variable "name" {
  description = "Cluster name"
  type        = string
  default     = "stockpnl"
}

variable "hosted_zone_id" {
  description = "The ID of the Route53 hosted zone"
  type        = string
  default     = "Z022564630P941WV72XMM" # Your hosted zone ID for stockpnl.com
}

variable "app_domain_name" {
  description = "Root domain for the app"
  type        = string
  default     = "stockpnl.com"
}
