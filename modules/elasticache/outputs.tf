output "redis_replication_group_id" {
  description = "ElastiCache Redis replication group ID"
  value       = aws_elasticache_replication_group.main.id
}

output "redis_primary_endpoint_address" {
  description = "ElastiCache Redis primary endpoint address"
  value       = aws_elasticache_replication_group.main.primary_endpoint_address
}

output "redis_reader_endpoint_address" {
  description = "ElastiCache Redis reader endpoint address"
  value       = aws_elasticache_replication_group.main.reader_endpoint_address
}

output "redis_port" {
  description = "ElastiCache Redis port"
  value       = aws_elasticache_replication_group.main.port
}

output "redis_subnet_group_name" {
  description = "ElastiCache Redis subnet group name"
  value       = aws_elasticache_subnet_group.main.name
}

output "redis_host_parameter_name" {
  description = "SSM parameter name for Redis host"
  value       = aws_ssm_parameter.redis_host.name
}

output "redis_port_parameter_name" {
  description = "SSM parameter name for Redis port"
  value       = aws_ssm_parameter.redis_port.name
}