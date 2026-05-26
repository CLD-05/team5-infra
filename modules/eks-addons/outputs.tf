output "eks_addon_names" {
  description = "EKS add-on names"
  value       = [for addon in aws_eks_addon.main : addon.addon_name]
}

output "eks_addon_arns" {
  description = "EKS add-on ARNs"
  value       = [for addon in aws_eks_addon.main : addon.arn]
}