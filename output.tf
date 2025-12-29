output "web_urls" {
  value       = module.ec2.instance_public_dns
  description = "The public DNS names of the web servers"
}

output "instance_public_dns" {
  value       = module.ec2.instance_public_dns
  description = "The public DNS of the EC2 instance"
}

output "SSH_Key_Command" {
  value       = module.ec2.ssh_command
  description = "The SSH command to connect to the instance"
}

output "instance_id" {
  value       = module.ec2.instance_id
  description = "The ID of the EC2 instance"
}

output "instance_public_ip" {
  value       = module.ec2.instance_public_ip
  description = "The public IP address of the EC2 instance"
}

output "ssh_key_path" {
  value       = module.ec2.ssh_key_path
  description = "Path to the private SSH key"
}