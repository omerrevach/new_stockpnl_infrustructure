output "public_subnets" {
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  value       = aws_subnet.private[*].id
}

output "public_cidr_blocks" {
  value       = aws_subnet.public[*].cidr_block
}

output "private_cidr_blocks" {
  value       = aws_subnet.private[*].cidr_block
}
