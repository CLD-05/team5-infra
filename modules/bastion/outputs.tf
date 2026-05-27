output "bastion_instance_id" {
  description = "Bastion Host instance ID"
  value       = try(aws_instance.bastion[0].id, null)
}

output "bastion_public_ip" {
  description = "Bastion Host public IP"
  value       = try(aws_instance.bastion[0].public_ip, null)
}

output "bastion_private_ip" {
  description = "Bastion Host private IP"
  value       = try(aws_instance.bastion[0].private_ip, null)
}