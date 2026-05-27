output "role_arn" {
  description = "AWS Load Balancer Controller IRSA Role ARN"
  value       = aws_iam_role.this.arn
}