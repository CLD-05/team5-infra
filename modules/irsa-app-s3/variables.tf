variable "name_prefix" {
  description = "Name prefix"
  type        = string
}

variable "oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  type        = string
}

variable "oidc_provider_url" {
  description = "EKS OIDC provider URL without https://"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for application"
  type        = string
}

variable "service_account_name" {
  description = "Kubernetes ServiceAccount name for application"
  type        = string
  default     = "petcarelog-app-sa"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "bucket_arn" {
  description = "S3 bucket ARN"
  type        = string
}

variable "image_prefix" {
  description = "S3 image prefix"
  type        = string
  default     = "pets"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}