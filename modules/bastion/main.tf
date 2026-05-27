# ------------------------------------------------------------------------------
# Amazon Linux 2023 AMI
# ------------------------------------------------------------------------------

data "aws_ami" "amazon_linux_2023" {
  count = var.enable_bastion ? 1 : 0

  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"
    values = [
      "al2023-ami-*-x86_64"
    ]
  }

  filter {
    name = "architecture"
    values = [
      "x86_64"
    ]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"
    ]
  }
}

# ------------------------------------------------------------------------------
# Bastion Host
# ------------------------------------------------------------------------------

resource "aws_instance" "bastion" {
  count = var.enable_bastion ? 1 : 0

  ami                         = data.aws_ami.amazon_linux_2023[0].id
  instance_type               = var.bastion_instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.bastion_sg_id]
  associate_public_ip_address = true
  key_name                    = var.bastion_key_name

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-bastion"
  })

  volume_tags = merge(var.tags, {
  Name = "${var.name_prefix}-bastion-root-volume"
})
}