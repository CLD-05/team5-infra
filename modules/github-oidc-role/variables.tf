variable "project_name" {
  description = "Project name"
  type        = string
}

variable "role_name" {
  description = "GitHub Actions IAM Role name"
  type        = string
}

variable "policy_name" {
  description = "ECR push IAM policy name"
  type        = string
}

variable "create_oidc_provider" {
  description = "Whether to create GitHub OIDC provider"
  type        = bool
  default     = true
}

variable "github_oidc_thumbprint" {
  description = "GitHub OIDC thumbprint"
  type        = string
  default     = "6938fd4d98bab03faadb97b34396831e3780aea1"
}

variable "github_sub_conditions" {
  description = "Allowed GitHub OIDC sub conditions"
  type        = list(string)
}

variable "ecr_repository_arns" {
  description = "ECR repository ARNs allowed for push"
  type        = list(string)
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}