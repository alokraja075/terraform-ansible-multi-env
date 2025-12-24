locals {
  key_dir = "${path.root}/key"
}

resource "null_resource" "SSHDir" {

  provisioner "local-exec" {
    command = "mkdir -p ${local.key_dir}"
  }
}

resource "null_resource" "SSHKey" {

  depends_on = [null_resource.SSHDir]

  provisioner "local-exec" {
    command = <<-EOF
      if [ ! -f "${local.key_dir}/${var.key_pair_name}" ]; then
        ssh-keygen -t rsa -b 4096 -f "${local.key_dir}/${var.key_pair_name}" -N ""
        chmod 400 "${local.key_dir}/${var.key_pair_name}"
      fi
    EOF
  }
}

# read file data
data "local_file" "public_key"{
  depends_on = [null_resource.SSHKey]
  filename = "${local.key_dir}/${var.key_pair_name}.pub"
}

# aws key pair name
resource "aws_key_pair" "EC2_Key"{
  depends_on = [null_resource.SSHKey]
  key_name = var.key_pair_name
  public_key = data.local_file.public_key.content
}

resource "aws_security_group" "Prod_Security_Group"{
  name = var.security_group_name
  description = "Prod Security Group"
}
resource "aws_security_group_rule" "ingress_rules" {
  for_each = var.ingress_rules
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.Prod_Security_Group.id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.key_pair_name
  vpc_security_group_ids  = [aws_security_group.Prod_Security_Group]
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 50
    volume_type = "gp3"
    delete_on_termination = true
  }
  tags = {
    Name = "HelloWorld"
  }
}