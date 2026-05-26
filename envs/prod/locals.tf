locals {
  name_prefix = "team5-${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"

    # IAM 정책에서 aws:RequestTag/team, aws:ResourceTag/team을 검사하므로 필요
    team = "team5"
  }
}