output "bucket_name" {
  description = "Backend S3 버킷 이름 (다음 단계에서 사용)"
  value       = aws_s3_bucket.backend.bucket
}

output "dynamodb_table" {
  description = "Lock DynamoDB 테이블 이름"
  value       = aws_dynamodb_table.lock.name
}

output "account_id" {
  description = "AWS 계정 ID"
  value       = data.aws_caller_identity.current.account_id
}
