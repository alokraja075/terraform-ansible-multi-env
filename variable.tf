variable "region" {
  type    = string
  default = "us-east-1"
}

variable "key_pair_name" {
  type    = string
  default = "TestKP"
}
variable "security_group_name"{
  type    = string
  default = "Test_SG"
}
variable "ingress_rules"{
  type = map(object({
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(string)
  }))
}
variable "egress_rules"{
  type = map(object({
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(string)
  }))
}
variable "instance_type"{
  type = string
  default   = "t2.micro"
}