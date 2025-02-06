output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.subnets.public_subnets
}

output "private_subnets" {
  value = module.subnets.private_subnets
}

output "igw_id" {
  value = module.igw.igw_id
}

output "nat_instance_network_interface_id" {
  value = module.nat.nat_instance_network_interface_id
}
