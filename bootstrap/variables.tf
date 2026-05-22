variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}


variable "state_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name"
  type        = string
}
