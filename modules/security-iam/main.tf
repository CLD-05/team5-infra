##########################################################
# ALB Security Group
##########################################################
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.name_prefix}-alb-sg" })
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "HTTP from internet"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "HTTPS from internet"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_eks_node" {
  security_group_id            = aws_security_group.alb.id
  from_port                    = 0
  to_port                      = 65535
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.eks_node.id
  description                  = "Outbound to EKS Node SG"
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

resource "aws_vpc_security_group_ingress_rule" "eks_cluster_from_node" {
  security_group_id            = aws_security_group.eks_cluster.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.eks_node.id
  description                  = "Node to Cluster API"
}

resource "aws_vpc_security_group_egress_rule" "eks_cluster_all" {
  security_group_id = aws_security_group.eks_cluster.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound"
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

resource "aws_vpc_security_group_ingress_rule" "eks_node_from_alb" {
  security_group_id            = aws_security_group.eks_node.id
  from_port                    = 0
  to_port                      = 65535
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
  description                  = "From ALB SG"
}

resource "aws_vpc_security_group_ingress_rule" "eks_node_from_cluster" {
  security_group_id            = aws_security_group.eks_node.id
  from_port                    = 0
  to_port                      = 65535
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.eks_cluster.id
  description                  = "From EKS Cluster SG"
}

resource "aws_vpc_security_group_ingress_rule" "eks_node_self" {
  security_group_id            = aws_security_group.eks_node.id
  from_port                    = 0
  to_port                      = 65535
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.eks_node.id
  description                  = "Node to Node"
}

resource "aws_vpc_security_group_egress_rule" "eks_node_all" {
  security_group_id = aws_security_group.eks_node.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound"
}

##########################################################
# RDS Security Group
##########################################################
resource "aws_security_group" "rds" {
  name        = "${var.name_prefix}-rds-sg"
  description = "RDS Security Group"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.name_prefix}-rds-sg" })
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_eks_node" {
  security_group_id            = aws_security_group.rds.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.eks_node.id
  description                  = "MySQL from EKS Node"
}

# dev 환경에서만 Bastion → RDS 허용
resource "aws_vpc_security_group_ingress_rule" "rds_from_bastion" {
  count = var.environment == "dev" ? 1 : 0

  security_group_id            = aws_security_group.rds.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.bastion[0].id
  description                  = "MySQL from Bastion (dev only)"
}

resource "aws_vpc_security_group_egress_rule" "rds_all" {
  security_group_id = aws_security_group.rds.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound"
}

##########################################################
# Bastion Security Group (dev only)
##########################################################
resource "aws_security_group" "bastion" {
  count = var.environment == "dev" ? 1 : 0

  name        = "${var.name_prefix}-bastion-sg"
  description = "Bastion Host Security Group (dev only)"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.name_prefix}-bastion-sg" })
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  for_each = var.environment == "dev" ? toset(var.bastion_allowed_ssh_cidrs) : toset([])

  security_group_id = aws_security_group.bastion[0].id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value
  description       = "SSH from allowed CIDR"
}

resource "aws_vpc_security_group_egress_rule" "bastion_to_rds" {
  count = var.environment == "dev" ? 1 : 0

  security_group_id            = aws_security_group.bastion[0].id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.rds.id
  description                  = "Outbound to RDS"
}

##########################################################
# EKS Cluster IAM Role
##########################################################
data "aws_iam_policy_document" "eks_cluster_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_cluster" {
  name               = "${var.name_prefix}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume.json
  tags               = merge(var.tags, { Name = "${var.name_prefix}-eks-cluster-role" })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

##########################################################
# EKS Node Group IAM Role
##########################################################
data "aws_iam_policy_document" "eks_node_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_node" {
  name               = "${var.name_prefix}-eks-node-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume.json
  tags               = merge(var.tags, { Name = "${var.name_prefix}-eks-node-role" })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_ecr_readonly" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# prod 환경 SSM Session Manager 지원
resource "aws_iam_role_policy_attachment" "eks_node_ssm" {
  count = var.environment == "prod" ? 1 : 0

  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
