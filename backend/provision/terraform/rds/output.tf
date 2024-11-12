output "username" {
  description = "The master username for the DB"
  value       = module.rds.db_instance_username
  sensitive   = true
}

output "password" {
  description = "The master password for the DB"
  value       = random_password.this.result
  sensitive   = true
}

output "endpoint" {
  description = "The IP address of the RDS instance"
  value       = module.rds.db_instance_endpoint
}

output "port" {
  description = "The port number of the RDS instance"
  value       = module.rds.db_instance_port
}

output "db_name" {
  description = "DB name that will be created during launching the RDS"
  value       = module.rds.db_instance_name
}