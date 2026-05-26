# ------------------------------------------------------------------------------
# Network
# ------------------------------------------------------------------------------

output "vpc_id" {
  description = "Management VPC ID"
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "Management VPC CIDR block"
  value       = module.network.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "Management public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Management private app subnet IDs"
  value       = module.network.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Management private DB subnet IDs"
  value       = module.network.private_db_subnet_ids
}

output "nat_gateway_ids" {
  description = "Management NAT Gateway IDs"
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
# EKS
# ------------------------------------------------------------------------------

output "eks_cluster_name" {
  description = "Management EKS cluster name"
  value       = module.eks.eks_cluster_name
}

output "eks_cluster_arn" {
  description = "Management EKS cluster ARN"
  value       = module.eks.eks_cluster_arn
}

output "eks_cluster_endpoint" {
  description = "Management EKS cluster endpoint"
  value       = module.eks.eks_cluster_endpoint
}

output "eks_node_group_name" {
  description = "Management EKS managed node group name"
  value       = module.eks.eks_node_group_name
}

output "eks_addon_names" {
  description = "Management EKS add-on names"
  value       = module.eks_addons.eks_addon_names
}