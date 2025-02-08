output "ebs_csi_role_arn" {
  value       = aws_iam_role.ebs_csi_role.arn
  description = "IAM Role ARN for EBS CSI Controller"
}
