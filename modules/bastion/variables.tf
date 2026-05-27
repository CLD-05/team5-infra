variable "name_prefix" {
  description = "Name prefix for all resources"
  type        = string
}

variable "enable_bastion" {
  description = "Whether to create Bastion Host"
  type        = bool
  default     = false
}

variable "public_subnet_id" {
  description = "Public subnet ID where Bastion Host will be created"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security Group ID for Bastion Host"
  type        = string
}

variable "bastion_instance_type" {
  description = "EC2 instance type for Bastion Host"
  type        = string
  default     = "t3.micro"
}

variable "bastion_key_name" {
  description = "EC2 Key Pair name for Bastion Host SSH access"
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
