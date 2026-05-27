# ------------------------------------------------------------------------------
# ECR
# ------------------------------------------------------------------------------

output "ecr_repository_name" {
  description = "ECR repository name"
  value       = module.ecr.repository_name
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "ECR repository ARN"
  value       = module.ecr.repository_arn
}

# ------------------------------------------------------------------------------
# GitHub OIDC Role
# ------------------------------------------------------------------------------

output "github_actions_role_arn" {
  description = "GitHub Actions IAM Role ARN"
  value       = module.github_oidc_role.role_arn
}

# ------------------------------------------------------------------------------
# Network
# ------------------------------------------------------------------------------

output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = module.network.vpc_cidr_block
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.network.internet_gateway_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private app subnet IDs"
  value       = module.network.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Private DB subnet IDs"
  value       = module.network.private_db_subnet_ids
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = module.network.nat_gateway_ids
}

# ------------------------------------------------------------------------------
# Security Group
# ------------------------------------------------------------------------------


output "eks_cluster_sg_id" {
  description = "EKS Cluster Security Group ID"
  value       = module.security_group.eks_cluster_sg_id
}

output "eks_node_sg_id" {
  description = "EKS Node Security Group ID"
  value       = module.security_group.eks_node_sg_id
}

output "rds_sg_id" {
  description = "RDS Security Group ID"
  value       = module.security_group.rds_sg_id
}

output "bastion_sg_id" {
  description = "Bastion Security Group ID. Prod does not create Bastion, so this is usually null."
  value       = module.security_group.bastion_sg_id
}

# ------------------------------------------------------------------------------
# IAM
# ------------------------------------------------------------------------------

output "eks_cluster_role_arn" {
  description = "EKS Cluster IAM Role ARN"
  value       = module.iam.eks_cluster_role_arn
}

output "eks_node_role_arn" {
  description = "EKS Node IAM Role ARN"
  value       = module.iam.eks_node_role_arn
}

# ------------------------------------------------------------------------------
# RDS
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

# ------------------------------------------------------------------------------
# SSM Parameter Store
# ------------------------------------------------------------------------------

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

output "db_port_parameter_name" {
  description = "SSM parameter name for DB port"
  value       = module.ssm_parameter.db_port_parameter_name
}

# 비밀번호 parameter 이름은 naming 규칙으로 관리하고, output으로 노출하지 않음.
# 예: team5-petcarelog-prod-db-password

# ------------------------------------------------------------------------------
# EKS
# ------------------------------------------------------------------------------

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.eks_cluster_name
}

output "eks_cluster_arn" {
  description = "EKS cluster ARN"
  value       = module.eks.eks_cluster_arn
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.eks_cluster_endpoint
}

output "eks_node_group_name" {
  description = "EKS managed node group name"
  value       = module.eks.eks_node_group_name
}

output "eks_addon_names" {
  description = "EKS add-on names"
  value       = module.eks_addons.eks_addon_names
}

# ------------------------------------------------------------------------------
# ElastiCache Redis
# ------------------------------------------------------------------------------

output "elasticache_sg_id" {
  description = "ElastiCache Redis Security Group ID"
  value       = module.security_group.elasticache_sg_id
}

output "redis_replication_group_id" {
  description = "ElastiCache Redis replication group ID"
  value       = module.elasticache.redis_replication_group_id
}

output "redis_primary_endpoint_address" {
  description = "ElastiCache Redis primary endpoint address"
  value       = module.elasticache.redis_primary_endpoint_address
}

output "redis_reader_endpoint_address" {
  description = "ElastiCache Redis reader endpoint address"
  value       = module.elasticache.redis_reader_endpoint_address
}

output "redis_port" {
  description = "ElastiCache Redis port"
  value       = module.elasticache.redis_port
}

output "redis_subnet_group_name" {
  description = "ElastiCache Redis subnet group name"
  value       = module.elasticache.redis_subnet_group_name
}

output "redis_host_parameter_name" {
  description = "SSM parameter name for Redis host"
  value       = module.elasticache.redis_host_parameter_name
}

output "redis_port_parameter_name" {
  description = "SSM parameter name for Redis port"
  value       = module.elasticache.redis_port_parameter_name
}

# alb
output "alb_controller_irsa_role_arn" {
  description = "AWS Load Balancer Controller IRSA Role ARN"
  value       = module.irsa_alb_controller.role_arn
}

# ------------------------------------------------------------------------------
# S3 Image Bucket / App IRSA
# ------------------------------------------------------------------------------

output "s3_image_bucket_name" {
  description = "S3 image bucket name"
  value       = module.s3_images.bucket_name
}

output "s3_image_bucket_arn" {
  description = "S3 image bucket ARN"
  value       = module.s3_images.bucket_arn
}

output "s3_image_prefix" {
  description = "S3 image prefix"
  value       = module.s3_images.image_prefix
}

output "app_s3_irsa_role_arn" {
  description = "PetCareLog app S3 IRSA Role ARN"
  value       = module.irsa_app_s3.role_arn
}