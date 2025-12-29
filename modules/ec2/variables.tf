variable "key_dir" {
  type        = string
  description = "Directory path where SSH keys are stored"
}

variable "key_pair_name" {
  type        = string
  description = "Name of the SSH key pair"
}

variable "security_group_name" {
  type        = string
  description = "Name of the security group"
}

variable "security_group_description" {
  type        = string
  description = "Description of the security group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the security group will be created"
  default     = null
}

variable "ingress_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "Ingress rules for the security group"
}

variable "egress_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "Egress rules for the security group"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "instance_name" {
  type        = string
  description = "Name tag for the EC2 instance"
}

variable "ebs_block_devices" {
  type = list(object({
    device_name           = string
    volume_size           = number
    volume_type           = string
    delete_on_termination = bool
  }))
  description = "EBS block devices to attach to the instance"
  default     = []
}

variable "user_data" {
  type        = string
  description = "User data script to run on instance launch"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the EC2 instance"
  default     = {}
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address with the instance"
  default     = true
}

variable "monitoring" {
  type        = bool
  description = "Enable detailed monitoring"
  default     = false
}

