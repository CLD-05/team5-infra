output "bucket_name" {
  description = "Backend S3 버킷 이름"
  value       = aws_s3_bucket.backend.bucket
}

output "dynamodb_table" {
  description = "Lock DynamoDB 테이블 이름"
  value       = aws_dynamodb_table.lock.name
}
