locals {
  # prod 환경에 맞는 접두사 생성 (team5-petcarelog-prod)
  name_prefix = "team5-${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Team        = "team5"
  }
}
