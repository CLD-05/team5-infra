output "ecr_repository_name" {
  description = "ECR repository name"
  value       = module.ecr.repository_name
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

output "github_actions_role_arn" {
  description = "GitHub Actions IAM Role ARN"
  value       = module.github_oidc_role.role_arn
}

# ------------------------------------------------------------------------------
# RDS / SSM Parameter
# ------------------------------------------------------------------------------
output "rds_instance_id" {
  description = "RDS instance ID"
  value       = module.rds.rds_instance_id
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.rds_endpoint
}

output "rds_address" {
  description = "RDS address"
  value       = module.rds.rds_address
}

output "rds_port" {
  description = "RDS port"
  value       = module.rds.rds_port
}

output "rds_db_name" {
  description = "RDS database name"
  value       = module.rds.rds_db_name
}

output "db_subnet_group_name" {
  description = "RDS subnet group name"
  value       = module.rds.db_subnet_group_name
}

output "db_host_parameter_name" {
  description = "SSM parameter name for DB host"
  value       = module.ssm_parameter.db_host_parameter_name
}

output "db_name_parameter_name" {
  description = "SSM parameter name for DB name"
  value       = module.ssm_parameter.db_name_parameter_name
}

output "db_username_parameter_name" {
  description = "SSM parameter name for DB username"
  value       = module.ssm_parameter.db_username_parameter_name
}

output "db_password_parameter_name" {
  description = "SSM parameter name for DB password"
  value       = module.ssm_parameter.db_password_parameter_name
}

output "db_port_parameter_name" {
  description = "SSM parameter name for DB port"
  value       = module.ssm_parameter.db_port_parameter_name
}