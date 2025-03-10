variable "aws_region" {
  type = string
  default = "us-west-2"
}

variable "aws_azs" {
  type = list(string)
  default = [ "us-west-2a", "us-west-2b" ]
}

variable "access_cidr" {
  type = string
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "gateway_ami" {
  default = "ami-027951e78de46a00e"
}

variable "gateway_type" {
  default = "t2.micro"
}

variable "aws_profile" {
  default = "berret-terry"
}