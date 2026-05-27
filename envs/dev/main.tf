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

  
  create_oidc_provider = false

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

  enable_alb_sg         = false
  enable_rds_sg         = true
  enable_elasticache_sg = true

  enable_bastion            = var.enable_bastion
  bastion_allowed_ssh_cidrs = var.bastion_allowed_ssh_cidrs

  db_port    = var.db_port
  app_port   = var.app_port
  redis_port = var.redis_port

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

# ------------------------------------------------------------------------------
# ElastiCache Redis
# ------------------------------------------------------------------------------

module "elasticache" {
  source = "../../modules/elasticache"

  name_prefix = local.name_prefix

  private_app_subnet_ids = module.network.private_app_subnet_ids
  elasticache_sg_id      = module.security_group.elasticache_sg_id

  redis_node_type                  = var.redis_node_type
  redis_engine_version             = var.redis_engine_version
  redis_port                       = var.redis_port
  redis_num_cache_clusters         = var.redis_num_cache_clusters
  redis_multi_az_enabled           = var.redis_multi_az_enabled
  redis_automatic_failover_enabled = var.redis_automatic_failover_enabled
  redis_at_rest_encryption_enabled = var.redis_at_rest_encryption_enabled
  redis_transit_encryption_enabled = var.redis_transit_encryption_enabled

  tags = local.common_tags

  depends_on = [
    module.security_group,
    module.network
  ]
}

module "eks" {
  source = "../../modules/eks"

  name_prefix = local.name_prefix

  private_app_subnet_ids = module.network.private_app_subnet_ids

  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn    = module.iam.eks_node_role_arn

  eks_cluster_sg_id = module.security_group.eks_cluster_sg_id

  eks_cluster_version         = var.eks_cluster_version
  eks_endpoint_public_access  = var.eks_endpoint_public_access
  eks_node_sg_id = module.security_group.eks_node_sg_id
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

module "irsa_alb_controller" {
  source = "../../modules/irsa-alb-controller"

  name_prefix = local.name_prefix

  eks_cluster_name  = module.eks.eks_cluster_name
  oidc_provider_arn = module.eks.eks_oidc_provider_arn
  oidc_provider_url = module.eks.eks_oidc_provider_url

  namespace            = "kube-system"
  service_account_name = "aws-load-balancer-controller"

  tags = local.common_tags

  depends_on = [
    module.eks
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