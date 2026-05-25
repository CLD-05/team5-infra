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

output "eks_cluster_certificate_authority_data" {
  description = "EKS cluster certificate authority data"
  value       = module.eks.eks_cluster_certificate_authority_data
  sensitive   = true
}

output "eks_node_group_name" {
  description = "EKS managed node group name"
  value       = module.eks.eks_node_group_name
}
