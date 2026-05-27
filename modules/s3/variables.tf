variable "name_prefix" {
  description = "Name prefix"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name. If null, bucket name is generated automatically."
  type        = string
  default     = null
}

variable "image_prefix" {
  description = "S3 prefix for uploaded pet images"
  type        = string
  default     = "pets"
}

variable "force_destroy" {
  description = "Whether to force destroy the bucket even if it contains objects"
  type        = bool
  default     = false
}

variable "cors_allowed_origins" {
  description = "Allowed origins for S3 CORS"
  type        = list(string)
  default     = ["*"]
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}