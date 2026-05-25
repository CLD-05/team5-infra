output "eks_addon_names" {
  description = "오류 없나? EKS 애드온 이름 목록 (디버깅용)"
  value       = [for addon in aws_eks_addon.this : addon.addon_name]
}