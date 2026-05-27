# ------------------------------------------------------------------------------
# Network
# ------------------------------------------------------------------------------

module "network" {
  source = "../../modules/network"

  name_prefix = local.name_prefix

  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  tags = local.common_tags
}

# ------------------------------------------------------------------------------
# Security Group
# ------------------------------------------------------------------------------

module "security_group" {
  source = "../../modules/security-group"

  name_prefix = local.name_prefix
  vpc_id      = module.network.vpc_id

  enable_alb_sg         = false
  enable_rds_sg         = false
  enable_elasticache_sg = false

  enable_bastion            = false
  bastion_allowed_ssh_cidrs = []

  db_port    = var.db_port
  app_port   = var.app_port
  redis_port = var.redis_port

  tags = local.common_tags
}

# ------------------------------------------------------------------------------
# IAM
# ------------------------------------------------------------------------------

module "iam" {
  source = "../../modules/iam"

  name_prefix = local.name_prefix

  tags = local.common_tags
}

# ------------------------------------------------------------------------------
# EKS
# ------------------------------------------------------------------------------

module "eks" {
  source = "../../modules/eks"

  name_prefix = local.name_prefix

  private_app_subnet_ids = module.network.private_app_subnet_ids

  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn    = module.iam.eks_node_role_arn

  eks_cluster_sg_id = module.security_group.eks_cluster_sg_id

  eks_cluster_version         = var.eks_cluster_version
  eks_endpoint_public_access  = var.eks_endpoint_public_access
  eks_endpoint_private_access = var.eks_endpoint_private_access
  eks_node_sg_id = module.security_group.eks_node_sg_id

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

# ------------------------------------------------------------------------------
# EKS Add-ons
# ------------------------------------------------------------------------------

module "eks_addons" {
  source = "../../modules/eks-addons"

  eks_cluster_name = module.eks.eks_cluster_name
  eks_addons       = var.eks_addons

  tags = local.common_tags

  depends_on = [
    module.eks
  ]
}

# ------------------------------------------------------------------------------
# Github OIDC Provider
# ------------------------------------------------------------------------------


module "github_oidc_provider" {
  source = "../../modules/github-oidc-provider"

  name_prefix = local.name_prefix

  tags = local.common_tags
}