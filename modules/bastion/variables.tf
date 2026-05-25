variable "enable_bastion" {
  description = "Bastion Host 생성 여부"
  type        = bool
}

variable "name_prefix" {
  description = "공통 접두어"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "Bastion이 배치될 첫 번째 public subnet ID"
  type        = string
}

variable "bastion_instance_type" {
  description = "Bastion 인스턴스 타입"
  type        = string
}

variable "bastion_key_name" {
  description = "EC2 Key Pair 이름"
  type        = string
}

variable "allowed_ssh_cidr_blocks" {
  description = "SSH 접속을 허용할 IP 대역 리스트"
  type        = list(string)
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
  default     = {}
}
