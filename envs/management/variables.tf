# ------------------------------------------------------------------------------
# Common
# ------------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

# ------------------------------------------------------------------------------
# VPC / Network
# ------------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "Private app subnet CIDR blocks"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "Private DB subnet CIDR blocks"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateway"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Whether to create a single NAT Gateway"
  type        = bool
  default     = true
}

# ------------------------------------------------------------------------------
# Bastion
# ------------------------------------------------------------------------------

variable "enable_bastion" {
  description = "Whether to create or allow Bastion Host access"
  type        = bool
  default     = false
}

variable "bastion_allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to access Bastion Host through SSH"
  type        = list(string)
  default     = []
}

# ------------------------------------------------------------------------------
# Ports
# ------------------------------------------------------------------------------

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 8080
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "redis_port" {
  description = "Redis port"
  type        = number
  default     = 6379
}

# ------------------------------------------------------------------------------
# EKS
# ------------------------------------------------------------------------------

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

# ------------------------------------------------------------------------------
# EKS Add-ons
# ------------------------------------------------------------------------------

variable "eks_addons" {
  description = "List of EKS add-ons to install"
  type        = list(string)
  default = [
    "vpc-cni",
    "coredns",
    "kube-proxy",
    "eks-pod-identity-agent"
  ]
}