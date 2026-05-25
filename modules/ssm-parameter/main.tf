# DB host 값을 SSM Parameter Store에 저장
resource "aws_ssm_parameter" "db_host" {
  name  = "${var.name_prefix}-db-host"
  type  = "String"
  value = var.db_host

  tags = var.tags
}

# DB 이름을 SSM Parameter Store에 저장
resource "aws_ssm_parameter" "db_name" {
  name  = "${var.name_prefix}-db-name"
  type  = "String"
  value = var.db_name

  tags = var.tags
}

# DB 유저 이름을 Parameter store에 저장
resource "aws_ssm_parameter" "db_username" {
  name  = "${var.name_prefix}-db-username"
  type  = "String"
  value = var.db_username

  tags = var.tags
}

# DB 비밀번호를 Parameter store에 저장
resource "aws_ssm_parameter" "db_password" {
  name  = "${var.name_prefix}-db-password"
  type  = "SecureString"
  value = var.db_password

  tags = var.tags
}

# DB 포트 번호를 SSM Parameter Store에 저장
resource "aws_ssm_parameter" "db_port" {
  name  = "${var.name_prefix}-db-port"
  type  = "String"
  value = tostring(var.db_port)

  tags = var.tags
}
