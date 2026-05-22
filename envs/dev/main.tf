locals {
  name_prefix = "${var.project}-${var.environment}"

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Team        = "team5"
    ManagedBy   = "terraform"
  }
}

module "ecr" {
  source = "../../modules/ecr"

  repository_name = local.name_prefix

  tags = local.common_tags
}

module "github_oidc_role" {
  source = "../../modules/github-oidc-role"

  name_prefix = local.name_prefix
  role_name   = "${local.name_prefix}-github-actions-role"

  github_org    = var.github_org
  github_repo   = var.github_repo
  github_branch = var.github_branch

  ecr_repository_arns = [
    module.ecr.repository_arn
  ]

  tags = local.common_tags
}
