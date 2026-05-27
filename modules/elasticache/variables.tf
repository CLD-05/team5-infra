variable "name_prefix" {
  description = "Name prefix for resources"
  type        = string
}

variable "private_app_subnet_ids" {
  description = "Private app subnet IDs for ElastiCache subnet group"
  type        = list(string)
}

variable "elasticache_sg_id" {
  description = "Security Group ID for ElastiCache Redis"
  type        = string
}

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
  description = "Number of cache clusters in the replication group"
  type        = number
  default     = 1
}

variable "redis_multi_az_enabled" {
  description = "Whether Multi-AZ is enabled for Redis"
  type        = bool
  default     = false
}

variable "redis_automatic_failover_enabled" {
  description = "Whether automatic failover is enabled for Redis"
  type        = bool
  default     = false
}

variable "redis_at_rest_encryption_enabled" {
  description = "Whether at-rest encryption is enabled"
  type        = bool
  default     = true
}

variable "redis_transit_encryption_enabled" {
  description = "Whether in-transit encryption is enabled"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}