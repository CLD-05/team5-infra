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

module "network" {
  source = "../../modules/network"

  name_prefix              = local.name_prefix
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  tags = local.common_tags
}

module "security_group" {
  source = "../../modules/security-group"

  name_prefix = local.name_prefix
  vpc_id      = module.network.vpc_id

  enable_bastion            = var.enable_bastion
  bastion_allowed_ssh_cidrs = var.bastion_allowed_ssh_cidrs

  db_port  = var.db_port
  app_port = var.app_port

  tags = local.common_tags
}

module "iam" {
  source = "../../modules/iam"

  name_prefix = local.name_prefix

  tags = local.common_tags
}

module "bastion" {
  source = "../../modules/bastion"

  name_prefix = local.name_prefix

  enable_bastion = var.enable_bastion

  public_subnet_id = module.network.public_subnet_ids[0]
  bastion_sg_id    = module.security_group.bastion_sg_id

  bastion_instance_type = var.bastion_instance_type
  bastion_key_name      = var.bastion_key_name

  tags = local.common_tags
}