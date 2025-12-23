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
  key_name = var.aws_key_pair
  public_key = data.local_file.public_key.content
}

resource "aws_security_group" "Prod_Security_Group"{
  
}
