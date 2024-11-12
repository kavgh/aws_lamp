output "username" {
  description = "The master username for the DB"
  value       = aws_db_instance.this.username
  sensitive   = true
}

output "password" {
  description = "The master password for the DB"
  value       = aws_db_instance.this.password
  sensitive   = true
}

output "endpoint" {
  description = "The IP address of the RDS instance"
  value       = aws_db_instance.this.endpoint
}

output "port" {
  description = "The port number of the RDS instance"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "DB name that will be created during launching the RDS"
  value       = aws_db_instance.this.db_name
}