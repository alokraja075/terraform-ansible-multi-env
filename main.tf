module "ec2" {
  source = "./modules/ec2"

  # Key pair configuration
  key_dir       = "${path.root}/key"
  key_pair_name = var.key_pair_name

  # Security group configuration
  security_group_name        = var.security_group_name
  security_group_description = var.security_group_description
  vpc_id                     = var.vpc_id

  # Instance configuration
  instance_type  = var.instance_type
  instance_name  = var.instance_name

  # Network configuration
  associate_public_ip_address = var.associate_public_ip_address
  monitoring                  = var.monitoring

  # Security rules
  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules

  # Storage configuration
  ebs_block_devices = var.ebs_block_devices

  # Tags
  tags = var.tags
}