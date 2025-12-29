output "instance_id" {
  value       = aws_instance.instance.id
  description = "The ID of the EC2 instance"
}

output "instance_public_ip" {
  value       = aws_instance.instance.public_ip
  description = "The public IP address of the EC2 instance"
}

output "instance_public_dns" {
  value       = aws_instance.instance.public_dns
  description = "The public DNS name of the EC2 instance"
}

output "security_group_id" {
  value       = aws_security_group.security_group.id
  description = "The ID of the security group"
}

output "key_pair_name" {
  value       = aws_key_pair.EC2_Key.key_name
  description = "The name of the SSH key pair"
}

output "ssh_command" {
  value       = "ssh -i ${local.key_dir}/${var.key_pair_name} ubuntu@${aws_instance.instance.public_dns}"
  description = "SSH command to connect to the instance"
}

output "ssh_key_path" {
  value       = "${local.key_dir}/${var.key_pair_name}"
  description = "Path to the private SSH key"
}
