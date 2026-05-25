variable "eks_cluster_name" {
  description = "EKS 클러스터 이름 (부모 모듈에서 전달받음)"
  type        = string
}

variable "eks_addons" {
  description = "설치할 EKS 애드온 목록 및 버전"
  type = map(object({
    addon_version = string
  }))
  default = {
    "vpc-cni" = {
      addon_version = null # null로 두면 AWS 최신 정품 버전이 자동으로 박힙니다!
    }
    "coredns" = {
      addon_version = null
    }
    "kube-proxy" = {
      addon_version = null
    }
    "eks-pod-identity-agent" = {
      addon_version = null
    }
  }
}

variable "tags" {
  description = "모든 리소스에 부여할 공통 태그 장부"
  type        = map(string)
  default     = {}
}