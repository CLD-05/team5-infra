# ------------------------------------------------------------------------------
# SSM Parameter Store - DB Connection Information 
# ------------------------------------------------------------------------------

# DB host 값을 SSM Parameter Store에 저장
resource "aws_ssm_parameter" "db_host" {
  name  = "${var.name_prefix}-db-host"
  description = "Database host for ${var.name_prefix}"
  type  = "String"
  value = var.db_host

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-db-host"
  })
}

# DB 이름을 SSM Parameter Store에 저장
resource "aws_ssm_parameter" "db_name" {
  name  = "${var.name_prefix}-db-name"
  description = "Database name for ${var.name_prefix}"
  type  = "String"
  value = var.db_name

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-db-name"
  })
}

# DB 유저 이름을 Parameter store에 저장
resource "aws_ssm_parameter" "db_username" {
  name  = "${var.name_prefix}-db-username"
  description = "Database username for ${var.name_prefix}"
  type  = "String"
  value = var.db_username

   tags = merge(var.tags, {
    Name = "${var.name_prefix}-db-username"
  })
}

# DB 비밀번호를 Parameter store에 저장
resource "aws_ssm_parameter" "db_password" {
  name  = "${var.name_prefix}-db-password"
  description = "Database password for ${var.name_prefix}"
  type  = "SecureString"
  value = var.db_password

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-db-password"
  })
}

# DB 포트 번호를 SSM Parameter Store에 저장
resource "aws_ssm_parameter" "db_port" {
  name  = "${var.name_prefix}-db-port"
  description = "Database port for ${var.name_prefix}"
  type  = "String"
  value = tostring(var.db_port)

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-db-port"
  })
}