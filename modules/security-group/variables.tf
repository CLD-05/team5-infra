variable "name_prefix" {
  description = "Name prefix for all resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "enable_bastion" {
  description = "Whether to allow Bastion access"
  type        = bool
  default     = false
}

variable "bastion_allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to access Bastion Host through SSH"
  type        = list(string)
  default     = []
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 8080
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "redis_port" {
  description = "Redis port"
  type        = number
  default     = 6379
}

