locals {
    key_dir = "${path.root}/key"
}

resource "null_resource" "SSHDir" {
    triggers = {
        key_dir=local.key_dir
    }
    provisioner "local-exec" {
        command ="mkdir  ${self.triggers.key_dir}"
    }
    provisioner "local-exec" {
        when = destroy
        command ="rm -rf  ${self.triggers.key_dir}"
    }
}
resource "null_resource" "SSHKey" {
    provisioner "local-exec" {
       command = <<-EOF
        if [ ! -f "${local.key_dir}/${var.key_pair_name}" ]; then
            ssh-keygen -t rsa  -b 4096 -f "$local.key_dir/$var.key_pair_name" -N ''
            chmod 400 "$local.key_dir/$var.key_pair_name"
        fi
        EOF
    }
}
