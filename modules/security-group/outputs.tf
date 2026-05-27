output "alb_sg_id" {
  description = "ALB Security Group ID"
  value       = var.enable_alb_sg ? aws_security_group.alb[0].id : null
}

output "eks_cluster_sg_id" {
  description = "EKS Cluster Security Group ID"
  value       = aws_security_group.eks_cluster.id
}

output "eks_node_sg_id" {
  description = "EKS Node Security Group ID"
  value       = aws_security_group.eks_node.id
}

output "rds_sg_id" {
  description = "RDS Security Group ID"
  value       = var.enable_rds_sg ? aws_security_group.rds[0].id : null
}

output "bastion_sg_id" {
  description = "Bastion Security Group ID"
  value       = var.enable_bastion ? aws_security_group.bastion[0].id : null
}

output "elasticache_sg_id" {
  description = "ElastiCache Redis Security Group ID"
  value       = var.enable_elasticache_sg ? aws_security_group.elasticache[0].id : null
}