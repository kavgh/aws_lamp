output "vpc_id" {
  description = "The ID of the VPC to associate with"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The list of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "ssh_sg_id" {
  description = "The ID of the security group that allow inbound SSH traffic"
  value       = module.vpc.ssh_sg_id
}

output "http_sg_id" {
  description = "The ID of the security group that allow inbound HTTP traffic"
  value       = module.vpc.http_sg_id
}

output "rds_endpoint" {
  description = "The endpoint for connecting to RDS"
  value       = module.rds.endpoint
}

output "mc_address" {
  description = "The DNS name for connecting to MC"
  value       = module.mc.address
}

output "mc_port" {
  description = "The port number for connecting to MC"
  value       = module.mc.port
}

output "rmq_endpoint" {
  description = "The endpoint for connecting to RMQ"
  value       = module.rmq.endpoint
}

output "rmq_username" {
  description = "The username for connecting to RMQ"
  value       = module.rmq.username
}

output "rmq_password" {
  description = "The password for connecting to RMQ"
  value       = module.rmq.password
  sensitive   = true
}

output "out_sg_id" {
  value = module.vpc.out_sg_id
}

output "sns_arn" {
  description = "The ARN of the SNS topic for subscription on events"
  value       = module.sns.sns_topic_arn
}