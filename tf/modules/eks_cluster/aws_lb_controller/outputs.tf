output "alb_controller_ready" {
  description = "Status of the AWS Load Balancer Controller"
  value       = helm_release.aws_load_balancer_controller.status
}

output "alb_controller_role_arn" {
  description = "ARN of the ALB Controller IAM role"
  value       = aws_iam_role.aws_load_balancer_controller.arn
}