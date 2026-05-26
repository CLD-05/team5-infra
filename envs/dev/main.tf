module "ecr" {
  source = "../../modules/ecr"

  repository_name = local.name_prefix

  tags = local.common_tags
}

module "github_oidc_role" {
  source = "../../modules/github-oidc-role"

  project_name = var.project_name

  role_name   = "${local.name_prefix}-github-actions-role"
  policy_name = "${local.name_prefix}-ecr-push-policy"

  # dev에서 GitHub OIDC Provider 최초 생성
  create_oidc_provider = true

  github_sub_conditions = [
    "repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/${var.github_branch}"
  ]

  ecr_repository_arns = [
    module.ecr.repository_arn
  ]

  tags = local.common_tags
}

module "rds" {
  source = "../../modules/rds"

  name_prefix = local.name_prefix

  private_db_subnet_ids = module.network.private_db_subnet_ids
  rds_sg_id             = module.security_group.rds_sg_id

  db_engine         = var.db_engine
  db_engine_version = var.db_engine_version
  db_instance_class = var.db_instance_class

  db_allocated_storage = var.db_allocated_storage
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_port              = var.db_port

  db_multi_az                = var.db_multi_az
  db_publicly_accessible     = var.db_publicly_accessible
  db_backup_retention_period = var.db_backup_retention_period
  db_deletion_protection     = var.db_deletion_protection
  db_skip_final_snapshot     = var.db_skip_final_snapshot

  tags = local.common_tags
}

module "ssm_parameter" {
  source = "../../modules/ssm-parameter"

  name_prefix = local.name_prefix

  db_host     = module.rds.rds_address
  db_name     = module.rds.rds_db_name
  db_username = var.db_username
  db_password = var.db_password
  db_port     = module.rds.rds_port

  tags = local.common_tags
}
