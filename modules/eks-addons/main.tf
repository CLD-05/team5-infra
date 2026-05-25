# EKS Add-ons 자동 반복 생성기 (for_each 마법 문법)
resource "aws_eks_addon" "this" {
  for_each = var.eks_addons

  cluster_name = var.eks_cluster_name
  addon_name   = each.key
  
  # 특정 버전을 명시하지 않으면 AWS 최신 정품 스펙으로 자동 매핑
  addon_version = each.value.addon_version

  # 실무 필수: 기존 클러스터 기본 애드온과 충돌 방지 덮어쓰기 설정
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  # 팀장님 필수 지시사항: 모든 자산 이름은 team5-
  tags = merge(
    {
      Name = "team5-${var.eks_cluster_name}-${each.key}-addon"
    },
    var.tags
  )
}