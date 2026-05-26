# ------------------------------------------------------------------------------
# ElastiCache Subnet Group
# ------------------------------------------------------------------------------

resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.name_prefix}-redis-subnet-group"
  subnet_ids = var.private_app_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-redis-subnet-group"
  })
}

# ------------------------------------------------------------------------------
# ElastiCache Redis Replication Group
# ------------------------------------------------------------------------------

resource "aws_elasticache_replication_group" "main" {
  replication_group_id = "${var.name_prefix}-redis"
  description          = "Redis replication group for ${var.name_prefix}"

  engine         = "redis"
  engine_version = var.redis_engine_version
  node_type      = var.redis_node_type
  port           = var.redis_port

  parameter_group_name = "default.redis7"

  subnet_group_name  = aws_elasticache_subnet_group.main.name
  security_group_ids = [var.elasticache_sg_id]

  num_cache_clusters         = var.redis_num_cache_clusters
  automatic_failover_enabled = var.redis_automatic_failover_enabled
  multi_az_enabled           = var.redis_multi_az_enabled

  at_rest_encryption_enabled = var.redis_at_rest_encryption_enabled

  # Spring Session Redis를 단순 연결로 먼저 검증하기 위해 false 권장
  # true로 바꾸면 애플리케이션 Redis TLS 설정도 같이 필요함
  transit_encryption_enabled = var.redis_transit_encryption_enabled

  apply_immediately = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-redis"
  })
}

# ------------------------------------------------------------------------------
# SSM Parameter Store for Redis
# ------------------------------------------------------------------------------

resource "aws_ssm_parameter" "redis_host" {
  name        = "${var.name_prefix}-redis-host"
  description = "Redis primary endpoint for ${var.name_prefix}"
  type        = "String"
  value       = aws_elasticache_replication_group.main.primary_endpoint_address

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-redis-host"
  })
}

resource "aws_ssm_parameter" "redis_port" {
  name        = "${var.name_prefix}-redis-port"
  description = "Redis port for ${var.name_prefix}"
  type        = "String"
  value       = tostring(var.redis_port)

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-redis-port"
  })
}