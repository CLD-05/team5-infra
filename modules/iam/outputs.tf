output "eks_cluster_role_name" {
  description = "EKS Cluster IAM Role name"
  value       = aws_iam_role.eks_cluster.name
}

output "eks_cluster_role_arn" {
  description = "EKS Cluster IAM Role ARN"
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_node_role_name" {
  description = "EKS Node IAM Role name"
  value       = aws_iam_role.eks_node.name
}

output "eks_node_role_arn" {
  description = "EKS Node IAM Role ARN"
  value       = aws_iam_role.eks_node.arn
}