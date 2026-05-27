variable "bucket_name" {
  description = "Name of the S3 bucket for pet images"
  type        = string
}

variable "environment" {
  description = "Environment name such as dev or prod"
  type        = string
}

variable "versioning_enabled" {
  description = "Whether to enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
