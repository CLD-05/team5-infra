# ------------------------------------------------------------------------------
# EKS Add-ons
# ------------------------------------------------------------------------------

resource "aws_eks_addon" "main" {
  for_each = toset(var.eks_addons)

  cluster_name = var.eks_cluster_name
  addon_name   = each.value

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = merge(var.tags, {
    Name = "${var.eks_cluster_name}-${each.value}"
  })
}