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


module "eks" {
  source = "../../modules/eks"

  name_prefix            = local.name_prefix
  private_app_subnet_ids = module.network.private_app_subnet_ids

  eks_cluster_role_arn = module.security_iam.eks_cluster_role_arn
  eks_node_role_arn    = module.security_iam.eks_node_role_arn

  eks_cluster_sg_id = module.security_iam.eks_cluster_sg_id

  eks_cluster_version = var.eks_cluster_version
  eks_endpoint_public_access  = var.eks_endpoint_public_access
  eks_endpoint_private_access = var.eks_endpoint_private_access

  node_group_instance_types = var.node_group_instance_types
  node_group_desired_size   = var.node_group_desired_size
  node_group_min_size       = var.node_group_min_size
  node_group_max_size       = var.node_group_max_size
  node_group_disk_size      = var.node_group_disk_size

  tags = local.common_tags

    depends_on = [
    module.iam,
    module.security_group
  ]
}

module "eks_addons" {
  source = "../../modules/eks-addons"

  eks_cluster_name = module.eks.eks_cluster_name
  eks_addons       = var.eks_addons

  tags = local.common_tags

  depends_on = [
    module.eks
  ]
}