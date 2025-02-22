output "alb_controller_ready" {
  value       = helm_release.aws_load_balancer_controller.status
}

output "alb_controller_role_arn" {
  value       = aws_iam_role.aws_load_balancer_controller.arn
}