output "irsa_role_arn" {
  value = aws_iam_role.irsa.arn
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "irsa_policy_arn" {
  value = aws_iam_policy.irsa.arn
}
