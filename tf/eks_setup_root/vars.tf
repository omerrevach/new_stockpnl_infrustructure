
variable "name" {
  description = "Cluster name"
  type        = string
  default     = "stockpnl"
}

variable "hosted_zone_id" {
  type        = string
  default     = "Z022564630P941WV72XMM" #  hosted zone ID for stockpnl.com
}

variable "app_domain_name" {
  type        = string
  default     = "stockpnl.com"
}
