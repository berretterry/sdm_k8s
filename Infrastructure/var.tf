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

variable "web_subnet_cidr" {
  type = string
  default = "10.0.1.0/24"
}

variable "app_subnet_cidr" {
  type = string
  default = "10.0.2.0/24"
}

variable "db_subnet_cidr" {
  type = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "mysql_username" {
  type = string
}

variable "mysql_pass" {
  type = string
}

variable "server_ami" {
  default = "ami-0aff18ec83b712f05"
}

variable "gateway_ami" {
  default = "ami-05312be62d5121de5"
}

variable "server_type" {
  default = "t2.micro"
}

variable "gateway_type" {
  default = "t2.medium"
}