data "aws_acm_certificate" "argocd" {
  domain      = "argocd.stockpnl.com"
  statuses    = ["ISSUED"]
  most_recent = true
}
