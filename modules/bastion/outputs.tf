output "bastion_instance_id" {
  value = one(aws_instance.bastion[*].id)
}

output "bastion_public_ip" {
  value = one(aws_instance.bastion[*].public_ip)
}

output "bastion_private_ip" {
  value = one(aws_instance.bastion[*].private_ip)
}
