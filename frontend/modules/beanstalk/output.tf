output "cname" {
  description = "The domain name of the beanstalk environment"
  value       = aws_elastic_beanstalk_environment.this.cname
}

output "URL" {
  description = "The URL of the load balancer in the beanstalk environment"
  value       = aws_elastic_beanstalk_environment.this.endpoint_url
}