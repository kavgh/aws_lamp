output "object_name" {
  description = "Name of the artifact in the S3 Bucket"
  value       = aws_s3_object.this.key
}

output "bucket_name" {
  description = "Name of the S3 Bucket where is stored an artifact"
  value       = aws_s3_bucket.this.bucket
}