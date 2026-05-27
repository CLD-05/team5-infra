output "bucket_name" {
  description = "S3 image bucket name"
  value       = aws_s3_bucket.images.bucket
}

output "bucket_arn" {
  description = "S3 image bucket ARN"
  value       = aws_s3_bucket.images.arn
}

output "bucket_domain_name" {
  description = "S3 bucket domain name"
  value       = aws_s3_bucket.images.bucket_domain_name
}

output "image_prefix" {
  description = "S3 image prefix"
  value       = var.image_prefix
}