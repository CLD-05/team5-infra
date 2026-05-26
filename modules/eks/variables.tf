variable "name_prefix" {
  description = "Common resource name prefix"
  type        = string
}

variable "private_app_subnet_ids" {
  description = "Private app subnet IDs for EKS worker nodes"
  type        = list(string)
}

variable "eks_cluster_role_arn" {
  description = "IAM role ARN for EKS cluster"
  type        = string
}

variable "eks_node_role_arn" {
  description = "IAM role ARN for EKS node group"
  type        = string
}

variable "eks_cluster_sg_id" {
  description = "Security group ID for EKS cluster"
  type        = string
}



variable "eks_cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
}

variable "eks_endpoint_public_access" {
  description = "Whether to enable public access to the EKS cluster endpoint"
  type        = bool
  default     = true
}

variable "eks_endpoint_private_access" {
  description = "Whether to enable private access to the EKS cluster endpoint"
  type        = bool
  default     = true
}

variable "node_group_instance_types" {
  description = "Instance types for EKS managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_group_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "node_group_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "node_group_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "node_group_disk_size" {
  description = "Disk size for EKS worker nodes"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}
