##########################################################
# ALB Security Group
##########################################################
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.name_prefix}-alb-sg" })
}

resource "aws_security_group_rule" "alb_http_ingress" {
  type              = "ingress"
  description       = "Allow HTTP from internet"
  security_group_id = aws_security_group.alb.id

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_https_ingress" {
  type              = "ingress"
  description       = "Allow HTTPS from internet"
  security_group_id = aws_security_group.alb.id

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_egress_all" {
  type              = "egress"
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.alb.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

##########################################################
# EKS Cluster Security Group
##########################################################
resource "aws_security_group" "eks_cluster" {
  name        = "${var.name_prefix}-eks-cluster-sg"
  description = "EKS Cluster Security Group"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.name_prefix}-eks-cluster-sg" })
}

resource "aws_security_group_rule" "eks_cluster_ingress_from_node_https" {
  type                     = "ingress"
  description              = "Allow worker nodes to communicate with EKS cluster API"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_node.id

  from_port = 443
  to_port   = 443
  protocol  = "tcp"
}

resource "aws_security_group_rule" "eks_cluster_ingress_from_bastion_https" {
  count = var.enable_bastion ? 1 : 0

  type                     = "ingress"
  description              = "Allow Bastion Host to access EKS cluster API"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.bastion[0].id

  from_port = 443
  to_port   = 443
  protocol  = "tcp"
}

resource "aws_security_group_rule" "eks_cluster_egress_all" {
  type              = "egress"
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.eks_cluster.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

##########################################################
# EKS Node Security Group
##########################################################
resource "aws_security_group" "eks_node" {
  name        = "${var.name_prefix}-eks-node-sg"
  description = "EKS Node Security Group"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.name_prefix}-eks-node-sg" })
}

resource "aws_security_group_rule" "eks_node_ingress_self" {
  type                     = "ingress"
  description              = "Allow node-to-node communication"
  security_group_id        = aws_security_group.eks_node.id
  source_security_group_id = aws_security_group.eks_node.id

  from_port = 0
  to_port   = 0
  protocol  = "-1"
}

resource "aws_security_group_rule" "eks_node_ingress_from_cluster_kubelet" {
  type                     = "ingress"
  description              = "Allow EKS cluster control plane to communicate with kubelet"
  security_group_id        = aws_security_group.eks_node.id
  source_security_group_id = aws_security_group.eks_cluster.id

  from_port = 10250
  to_port   = 10250
  protocol  = "tcp"
}

resource "aws_security_group_rule" "eks_node_ingress_from_cluster_ephemeral" {
  type                     = "ingress"
  description              = "Allow EKS cluster control plane to communicate with worker nodes"
  security_group_id        = aws_security_group.eks_node.id
  source_security_group_id = aws_security_group.eks_cluster.id

  from_port = 1025
  to_port   = 65535
  protocol  = "tcp"
}

resource "aws_security_group_rule" "eks_node_ingress_from_alb_app" {
  type                     = "ingress"
  description              = "Allow ALB to access application port on worker nodes"
  security_group_id        = aws_security_group.eks_node.id
  source_security_group_id = aws_security_group.alb.id

  from_port = var.app_port
  to_port   = var.app_port
  protocol  = "tcp"
}

resource "aws_security_group_rule" "eks_node_ingress_from_alb_nodeport" {
  type                     = "ingress"
  description              = "Allow ALB to access Kubernetes NodePort range"
  security_group_id        = aws_security_group.eks_node.id
  source_security_group_id = aws_security_group.alb.id

  from_port = 30000
  to_port   = 32767
  protocol  = "tcp"
}

resource "aws_security_group_rule" "eks_node_egress_all" {
  type              = "egress"
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.eks_node.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

##########################################################
# RDS Security Group
##########################################################

resource "aws_security_group" "rds" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Security group for RDS MySQL"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-rds-sg"
  })
}

resource "aws_security_group_rule" "rds_ingress_from_eks_node" {
  type                     = "ingress"
  description              = "Allow MySQL access from EKS worker nodes"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = aws_security_group.eks_node.id

  from_port = var.db_port
  to_port   = var.db_port
  protocol  = "tcp"
}

# dev 환경에서만 Bastion → RDS 허용
resource "aws_security_group_rule" "rds_ingress_from_bastion" {
  count = var.enable_bastion ? 1 : 0

  type                     = "ingress"
  description              = "Allow MySQL access from Bastion Host"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = aws_security_group.bastion[0].id

  from_port = var.db_port
  to_port   = var.db_port
  protocol  = "tcp"
}

resource "aws_security_group_rule" "rds_egress_all" {
  type              = "egress"
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.rds.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

##########################################################
# Bastion Security Group (dev only)
##########################################################
resource "aws_security_group" "bastion" {
  count = var.enable_bastion ? 1 : 0  

  name        = "${var.name_prefix}-bastion-sg"
  description = "Bastion Host Security Group (dev only)"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.name_prefix}-bastion-sg" })
}

resource "aws_security_group_rule" "bastion_ssh_ingress" {
  count = var.enable_bastion ? 1 : 0

  type              = "ingress"
  description       = "Allow SSH access to Bastion Host"
  security_group_id = aws_security_group.bastion[0].id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = var.bastion_allowed_ssh_cidrs
}

resource "aws_security_group_rule" "bastion_egress_all" {
  count = var.enable_bastion ? 1 : 0

  type              = "egress"
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.bastion[0].id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}