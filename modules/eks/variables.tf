variable "name_prefix" {
  description = "Name prefix for all resources"
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
  description = "IAM role ARN for EKS managed node group"
  type        = string
}

variable "eks_cluster_sg_id" {
  description = "Security Group ID for EKS cluster"
  type        = string
}


variable "eks_cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.33"
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
  description = "EC2 instance types for EKS managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in EKS managed node group"
  type        = number
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in EKS managed node group"
  type        = number
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in EKS managed node group"
  type        = number
}

variable "node_group_disk_size" {
  description = "Disk size in GB for EKS worker nodes"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "eks_node_sg_id" {
  description = "Security Group ID for EKS worker nodes"
  type        = string
}