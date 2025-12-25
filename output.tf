output "web_urls"{
  value = aws_instance.example.public_dns
  description = "The public DNS names of the web servers"
}
output "SSH_Key_Command"{
  value = "ssh -i ${local.key_dir}/${var.key_pair_name} ubuntu@${aws_instance.example.public_dns}"
  description = "The SSH command to connect to the instance"
}