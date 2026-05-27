# ------------------------------------------------------------------------------
# EKS Cluster
# ------------------------------------------------------------------------------

resource "aws_eks_cluster" "main" {
  name     = "${var.name_prefix}-eks"
  role_arn = var.eks_cluster_role_arn
  version  = var.eks_cluster_version

  vpc_config {
    subnet_ids = var.private_app_subnet_ids

    security_group_ids = [
      var.eks_cluster_sg_id
    ]

    endpoint_public_access  = var.eks_endpoint_public_access
    endpoint_private_access = var.eks_endpoint_private_access
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-eks"
  })
}

# ------------------------------------------------------------------------------
# EKS Managed Node Group
# ------------------------------------------------------------------------------

resource "aws_launch_template" "eks_node" {
  name_prefix = "${var.name_prefix}-node-lt-"

  vpc_security_group_ids = [
    var.eks_node_sg_id
  ]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.node_group_disk_size
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.tags, {
      Name = "${var.name_prefix}-eks-node"
    })
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(var.tags, {
      Name = "${var.name_prefix}-eks-node-volume"
    })
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-node-lt"
  })
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.name_prefix}-node-group"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.private_app_subnet_ids

  instance_types = var.node_group_instance_types

  launch_template {
    id      = aws_launch_template.eks_node.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = var.node_group_desired_size
    min_size     = var.node_group_min_size
    max_size     = var.node_group_max_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-node-group"
  })
}



# ------------------------------------------------------------------------------
# EKS OIDC Provider for IRSA
# ------------------------------------------------------------------------------

data "tls_certificate" "eks_oidc" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint
  ]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-eks-oidc-provider"
  })
}