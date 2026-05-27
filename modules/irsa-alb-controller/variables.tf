variable "name_prefix" {
  description = "Name prefix"
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
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
  description = "Kubernetes namespace for AWS Load Balancer Controller"
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "ServiceAccount name for AWS Load Balancer Controller"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}