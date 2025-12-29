locals {
  key_dir = var.key_dir
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
data "local_file" "public_key" {
  depends_on = [null_resource.SSHKey]
  filename   = "${local.key_dir}/${var.key_pair_name}.pub"
}

# aws key pair name
resource "aws_key_pair" "EC2_Key" {
  depends_on = [null_resource.SSHKey]
  key_name   = var.key_pair_name
  public_key = data.local_file.public_key.content
}

resource "aws_security_group" "security_group" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = var.security_group_name
    }
  )
}

resource "aws_security_group_rule" "ingress_rules" {
  for_each          = var.ingress_rules
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.security_group.id
}

resource "aws_security_group_rule" "egress_rule" {
  for_each          = var.egress_rules
  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.security_group.id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.security_group.id]
  associate_public_ip_address = var.associate_public_ip_address
  monitoring             = var.monitoring

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {
      device_name           = ebs_block_device.value.device_name
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = ebs_block_device.value.volume_type
      delete_on_termination = ebs_block_device.value.delete_on_termination
    }
  }

  # user_data can be used alternatively to Ansible for initial setup
  # user_data = var.user_data != "" ? base64encode(var.user_data) : null

  tags = merge(
    var.tags,
    {
      Name = var.instance_name
    }
  )

  depends_on = [aws_key_pair.EC2_Key]
}

