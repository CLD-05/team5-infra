#RDS가 들어갈 DB 전용 서브넷 묶음
resource "aws_db_subnet_group" "this" {
  name        = "${var.name_prefix}-db-subnet-group"
  description = "DB subnet group for ${var.name_prefix}"
  # root main.tf에서 module.network.private_db_subnet_ids를 넘겨받는 값
  subnet_ids = var.private_db_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-db-subnet-group"
  })
}

# 실제 DB 서버를 만드는 부분
resource "aws_db_instance" "this" {
  # RDS 이름
  identifier = "${var.name_prefix}-mysql"

  # DB 엔진 설정
  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  # 스토리지 설정
  allocated_storage = var.db_allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true

  # DB 접속 정보 (비밀번호는 올리면 X)
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  # RDS가 들어갈 네트워크 위치
  db_subnet_group_name = aws_db_subnet_group.this.name
  # SG (SG 설정에 맞게 수정해야 함)
  vpc_security_group_ids = [var.rds_sg_id]

  # 접근
  publicly_accessible = var.db_publicly_accessible
  multi_az            = var.db_multi_az

  # 자동 백업, RDS 삭제 방지, 스냅샷 생략
  backup_retention_period = var.db_backup_retention_period
  deletion_protection     = var.db_deletion_protection
  skip_final_snapshot     = var.db_skip_final_snapshot

  auto_minor_version_upgrade = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-mysql"
  })
}
