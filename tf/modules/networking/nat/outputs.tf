output "nat_instance_id" {
  value       = aws_instance.ec2_instance.id
}

output "nat_instance_public_ip" {
  value       = aws_instance.ec2_instance.public_ip
}

output "nat_instance_network_interface_id" {
  value       = aws_instance.ec2_instance.primary_network_interface_id
}
