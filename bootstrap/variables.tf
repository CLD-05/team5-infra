variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "team5-petcarelog"
}

variable "managed_by" {
  description = "Managed by"
  type        = string
  default     = "terraform"
}

variable "purpose" {
  description = "Purpose of this bootstrap"
  type        = string
  default     = "backend-bootstrap"
}

variable "state_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name"
  type        = string
}
