output "ebs_csi_role_arn" {
  value       = module.ebs_csi_driver.ebs_csi_role_arn
  description = "IAM Role ARN for EBS CSI Controller"
}
