locals {
  name_prefix = "team5-${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Team        = "team5"
  }
}

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

module "eks" {
  source = "../../modules/eks"

  name_prefix            = local.name_prefix
  private_app_subnet_ids = module.network.private_app_subnet_ids

  eks_cluster_role_arn = module.security_iam.eks_cluster_role_arn
  eks_node_role_arn    = module.security_iam.eks_node_role_arn

  eks_cluster_sg_id = module.security_iam.eks_cluster_sg_id
  eks_node_sg_id    = module.security_iam.eks_node_sg_id

  eks_cluster_version = var.eks_cluster_version

  node_group_instance_types = ["t3.medium"]
  node_group_desired_size   = 2
  node_group_min_size       = 1
  node_group_max_size       = 3
  node_group_disk_size      = 20

  tags = local.common_tags
}
