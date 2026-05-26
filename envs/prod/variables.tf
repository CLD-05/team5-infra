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
# GitHub / OIDC
# ------------------------------------------------------------------------------

variable "github_owner" {
  description = "GitHub organization or owner"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch allowed to assume role"
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
  default     = false
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

variable "bastion_instance_type" {
  description = "EC2 instance type for Bastion Host"
  type        = string
  default     = "t3.micro"
}

variable "bastion_key_name" {
  description = "EC2 key pair name for Bastion Host SSH access"
  type        = string
  default     = null
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

# ------------------------------------------------------------------------------
# RDS
# ------------------------------------------------------------------------------

variable "db_engine" {
  description = "RDS database engine"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "RDS database engine version"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage size for RDS in GB"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
}

variable "db_password" {
  description = "Master password for RDS. Do not commit real values to Git."
  type        = string
  sensitive   = true
}

variable "db_multi_az" {
  description = "Whether to enable Multi-AZ for RDS"
  type        = bool
  default     = true
}

variable "db_publicly_accessible" {
  description = "Whether RDS is publicly accessible"
  type        = bool
  default     = false
}

variable "db_backup_retention_period" {
  description = "RDS backup retention period in days"
  type        = number
  default     = 7
}

variable "db_deletion_protection" {
  description = "Whether to enable deletion protection for RDS"
  type        = bool
  default     = true
}

variable "db_skip_final_snapshot" {
  description = "Whether to skip final snapshot when deleting RDS"
  type        = bool
  default     = false
}

# ------------------------------------------------------------------------------
# EKS
# ------------------------------------------------------------------------------

variable "eks_cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.30"
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

# ------------------------------------------------------------------------------
# ElastiCache Redis
# ------------------------------------------------------------------------------

variable "redis_node_type" {
  description = "ElastiCache Redis node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "redis_engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.1"
}

variable "redis_port" {
  description = "Redis port"
  type        = number
  default     = 6379
}

variable "redis_num_cache_clusters" {
  description = "Number of Redis cache clusters"
  type        = number
  default     = 1
}

variable "redis_multi_az_enabled" {
  description = "Whether Redis Multi-AZ is enabled"
  type        = bool
  default     = false
}

variable "redis_automatic_failover_enabled" {
  description = "Whether Redis automatic failover is enabled"
  type        = bool
  default     = false
}

variable "redis_at_rest_encryption_enabled" {
  description = "Whether Redis at-rest encryption is enabled"
  type        = bool
  default     = true
}

variable "redis_transit_encryption_enabled" {
  description = "Whether Redis in-transit encryption is enabled"
  type        = bool
  default     = false
}