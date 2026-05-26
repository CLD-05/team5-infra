variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name. Must be dev or prod"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be either dev or prod."
  }
}

# ------------------------------------------------------------------------------
# GitHub / CI
# ------------------------------------------------------------------------------

variable "github_owner" {
  description = "GitHub organization or owner name"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name that runs GitHub Actions"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch allowed to assume the GitHub Actions IAM role"
  type        = string
}

# ------------------------------------------------------------------------------
# Network
# ------------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones used for subnet placement"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "Private application subnet CIDR blocks for EKS worker nodes and pods"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "Private database subnet CIDR blocks for RDS subnet group"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# NAT Gateway
# ------------------------------------------------------------------------------

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateway"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Whether to create only one NAT Gateway. For dev, true can reduce cost. For prod, false is recommended."
  type        = bool
  default     = false
}

# # ------------------------------------------------------------------------------
# # Bastion
# # ------------------------------------------------------------------------------

variable "enable_bastion" {
  description = "Whether to create a Bastion Host. Usually true for dev and false for prod."
  type        = bool
  default     = false  # dev 환경은 true이고 prod 환경은 false
}

# variable "bastion_instance_type" {
#   description = "EC2 instance type for Bastion Host"
#   type        = string
#   default     = "t3.micro"
# }

variable "bastion_allowed_ssh_cidrs" {
  description = "Bastion SSH 허용 CIDR (dev only)"
  type        = list(string)
  default     = []
}

# variable "bastion_key_name" {
#   description = "EC2 key pair name for Bastion Host SSH access"
#   type        = string
#   default     = null
# }


# # ------------------------------------------------------------------------------
# # APP
# # ------------------------------------------------------------------------------
variable "app_port" {
  description = "Application port"
  type        = number
  default     = 8080
}


# # ------------------------------------------------------------------------------
# # RDS
# # ------------------------------------------------------------------------------

# variable "db_engine" {
#   description = "RDS database engine"
#   type        = string
#   default     = "mysql"
# }

# variable "db_engine_version" {
#   description = "RDS database engine version"
#   type        = string
#   default     = "8.0"
# }

# variable "db_instance_class" {
#   description = "RDS instance class"
#   type        = string
#   default     = "db.t3.micro"
# }

# variable "db_allocated_storage" {
#   description = "Allocated storage size for RDS in GB"
#   type        = number
#   default     = 20
# }

# variable "db_name" {
#   description = "Initial database name"
#   type        = string
# }

# variable "db_username" {
#   description = "Master username for RDS"
#   type        = string
# }

# variable "db_password" {
#   description = "Master password for RDS. Do not commit real values to Git."
#   type        = string
#   sensitive   = true
# }

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

# variable "db_multi_az" {
#   description = "Whether to enable Multi-AZ for RDS"
#   type        = bool
#   default     = false
# }

# variable "db_publicly_accessible" {
#   description = "Whether RDS is publicly accessible"
#   type        = bool
#   default     = false
# }

# variable "db_backup_retention_period" {
#   description = "RDS backup retention period in days"
#   type        = number
#   default     = 1
# }

# variable "db_deletion_protection" {
#   description = "Whether to enable deletion protection for RDS"
#   type        = bool
#   default     = false
# }

# variable "db_skip_final_snapshot" {
#   description = "Whether to skip final snapshot when deleting RDS"
#   type        = bool
#   default     = true
# }

# # ------------------------------------------------------------------------------
# # SSM Parameter Store
# # ------------------------------------------------------------------------------

# variable "use_ssm_parameter_store" {
#   description = "Whether to store DB connection information in SSM Parameter Store"
#   type        = bool
#   default     = true
# }

# # ------------------------------------------------------------------------------
# # EKS
# # ------------------------------------------------------------------------------

# variable "eks_cluster_version" {
#   description = "EKS Kubernetes version"
#   type        = string
#   default     = "1.30"
# }

# variable "eks_endpoint_public_access" {
#   description = "Whether to enable public access to the EKS cluster endpoint"
#   type        = bool
#   default     = true
# }

# variable "eks_endpoint_private_access" {
#   description = "Whether to enable private access to the EKS cluster endpoint"
#   type        = bool
#   default     = true
# }

# variable "node_group_instance_types" {
#   description = "EC2 instance types for EKS managed node group"
#   type        = list(string)
#   default     = ["t3.medium"]
# }

# variable "node_group_desired_size" {
#   description = "Desired number of nodes in EKS managed node group"
#   type        = number
# }

# variable "node_group_min_size" {
#   description = "Minimum number of nodes in EKS managed node group"
#   type        = number
# }

# variable "node_group_max_size" {
#   description = "Maximum number of nodes in EKS managed node group"
#   type        = number
# }

# variable "node_group_disk_size" {
#   description = "Disk size in GB for EKS worker nodes"
#   type        = number
#   default     = 20
# }

# # ------------------------------------------------------------------------------
# # EKS Add-ons
# # ------------------------------------------------------------------------------

# variable "enable_eks_addons" {
#   description = "Whether to enable default EKS add-ons"
#   type        = bool
#   default     = true
# }

# variable "eks_addons" {
#   description = "List of EKS add-ons to install"
#   type        = list(string)
#   default = [
#     "vpc-cni",
#     "coredns",
#     "kube-proxy",
#     "eks-pod-identity-agent"
#   ]
# }


