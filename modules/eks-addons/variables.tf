variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "eks_addons" {
  description = "List of EKS add-ons to install"
  type        = list(string)
  default = [
    "vpc-cni",
    "coredns",
    "kube-proxy",
    "eks-pod-identity-agent"
  ]
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}