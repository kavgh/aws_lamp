output "password" {
  description = "The password to the MQ console"
  value       = random_password.this.result
  sensitive   = true
}

output "username" {
  description = "The username to the MQ console"
  value       = var.username
}

output "endpoint" {
  description = "The endpoint for connecting to RMQ instance"
  value       = aws_mq_broker.this.instances.0.endpoints.0
}