output "domain_name" {
  description = "The domain name to CDN"
  value       = aws_cloudfront_distribution.this.domain_name
}