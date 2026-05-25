# 최신 Amazon Linux 2023 AMI 조회
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Bastion 전용 보안 그룹 (0.0.0.0/0 차단)
resource "aws_security_group" "bastion" {
  count       = var.enable_bastion ? 1 : 0
  name        = "${var.name_prefix}-bastion-sg"
  description = "Security Group for Petcarelog Bastion Host"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from allowed CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-bastion-sg" })
}

# Bastion EC2 인스턴스 생성
resource "aws_instance" "bastion" {
  count = var.enable_bastion ? 1 : 0

  ami                         = data.aws_ami.al2023.id
  instance_type               = var.bastion_instance_type
  subnet_id                   = var.public_subnet_id
  key_name                    = var.bastion_key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.bastion[0].id]

  tags = merge(var.tags, { Name = "${var.name_prefix}-bastion" })
}
