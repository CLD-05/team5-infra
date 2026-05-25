variable "name_prefix" {
  description = "리소스 이름 prefix (예: team5-petcarelog-dev)"
  type        = string
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "environment" {
  description = "환경 (dev | prod)"
  type        = string
}

variable "bastion_allowed_ssh_cidrs" {
  description = "Bastion SSH 허용 CIDR 목록 (dev only)"
  type        = list(string)
  default     = []
}
