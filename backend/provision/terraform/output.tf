output "pkey" {
  value = aws_key_pair.this.key_name
}

output "db_endpoint" {
  value = module.rds.endpoint
}

output "db_name" {
  value = module.rds.db_name
}

output "db_username" {
  value = module.rds.username
  sensitive = true
}

output "db_password" {
  value = module.rds.password
  sensitive = true
}

output "iam_profile" {
  value = aws_iam_instance_profile.this.name
}

output "db_port" {
  value = module.rds.port
}

output "subnet_id" {
  value = data.aws_subnets.this.ids[0]
}