output "rds_endpoint" {
  description = "RDS endpoint with port"
  value       = aws_db_instance.this.endpoint
}

output "rds_address" {
  description = "RDS address"
  value       = aws_db_instance.this.address
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.this.port
}

output "rds_db_name" {
  description = "RDS database name"
  value       = aws_db_instance.this.db_name
}

output "rds_instance_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.this.id
}

output "db_subnet_group_name" {
  description = "DB subnet group name"
  value       = aws_db_subnet_group.this.name
}
