output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the VPC public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "IDs of the VPC private subnets"
  value       = module.vpc.private_subnets
}

output "name" {
  value = module.vpc.name
}

output "out_sg_id" {
  description = "Security group for outbound traffic"
  value       = aws_security_group.out.id
}

output "ssh_sg_id" {
  description = "Security group for the inbound SSH traffic"
  value       = aws_security_group.this["ssh"].id
}

output "http_sg_id" {
  description = "Security group for the inbound HTTP traffic"
  value       = aws_security_group.this["http"].id
}