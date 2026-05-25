module "bastion" {
  source = "../../modules/bastion"

  enable_bastion          = false # prod 환경이므로 생성 안 함
  name_prefix             = local.name_prefix
  vpc_id                  = module.network.vpc_id
  public_subnet_id        = module.network.public_subnet_ids[0]
  bastion_instance_type   = "t3.micro"
  bastion_key_name        = "prod-not-used-key" # 에러 방지용 더미 값
  allowed_ssh_cidr_blocks = ["10.0.0.0/16"]

  tags = local.common_tags
}
