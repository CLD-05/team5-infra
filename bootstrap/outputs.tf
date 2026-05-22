output "state_bucket_name" {
  description = "Backend S3 버킷 이름"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "lock_table_name" {
  description = "Lock DynamoDB 테이블 이름"
  value       = aws_dynamodb_table.terraform_lock.name
}
