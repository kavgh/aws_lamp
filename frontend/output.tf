output "cname" {
  description = "The URL to the beanstalk environment"
  value       = module.beanstalk.cname
}

output "domain_name" {
  description = "The domain name of the CDN"
  value       = module.cloudfront.domain_name
}