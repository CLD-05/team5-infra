output "db_host_parameter_name" {
  value = aws_ssm_parameter.db_host.name
}

output "db_name_parameter_name" {
  value = aws_ssm_parameter.db_name.name
}

output "db_username_parameter_name" {
  value = aws_ssm_parameter.db_username.name
}

output "db_password_parameter_name" {
  value     = aws_ssm_parameter.db_password.name
  sensitive = true
}

output "db_port_parameter_name" {
  value = aws_ssm_parameter.db_port.name
}
