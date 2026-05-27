output "role_arn" {
  description = "App S3 IRSA Role ARN"
  value       = aws_iam_role.this.arn
}

output "service_account_name" {
  description = "Kubernetes ServiceAccount name"
  value       = var.service_account_name
}