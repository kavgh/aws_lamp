output "service_role_arn" {
  description = "The ARN of the service role to attach to an elasticbeanstalk"
  value       = aws_iam_role.service.arn
}

output "instance_profile_arn" {
  description = "The ARN of the EC2 instance profile to attach to EC2 instance in an elasticbeanstalk"
  value       = aws_iam_instance_profile.this.arn
}