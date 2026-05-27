variable "name_prefix" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "cluster_oidc_issuer_url" {
  type = string
}

variable "namespace" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "pet_image_bucket_arn" {
  description = "ARN of the S3 bucket used for pet image storage. Do not pass the Terraform backend state bucket ARN."
  type        = string
}
