### Creating VPC
resource "aws_vpc" "sdm_k8s_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "SDM Challenge VPC"
  }
}

### Creating Public Subnets
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnets)
  vpc_id                  = aws_vpc.sdm_k8s_vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.aws_azs, count.index)
  map_public_ip_on_launch = true


  tags = {
    Name                              = "Public Subnet ${count.index + 1}"
    "kubernetes.io/role/elb"          = "1"
    "kubernetes.io/cluster/demo"       = "owned"
  }
}

### Creating Private Subnets
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets)
  vpc_id                  = aws_vpc.sdm_k8s_vpc.id
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.aws_azs, count.index)
  map_public_ip_on_launch = false


  tags = {
    Name                               = "Private Subnet ${count.index + 1}"
    "kubernetes.io/role/internal-elb"  = "1"
    "kubernetes.io/cluster/demo"       = "owned"
  }
}

### Creating VPC Internet Gateway
resource "aws_internet_gateway" "sdm_k8s_igw" {
  vpc_id = aws_vpc.sdm_k8s_vpc.id

  tags = {
    Name = "sdm_k8s IGW"
  }
}

### Creating Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "NAT EIP"
  }
}

### Creating NAT Gateway for Internet Access
resource "aws_nat_gateway" "sdm_k8s_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  depends_on = [aws_internet_gateway.sdm_k8s_igw]

  tags = {
    Name = "SDM k8s NAT"
  }
}

### Creating Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.sdm_k8s_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sdm_k8s_igw.id
  }

  tags = {
    Name = "SDM k8s Public RT"
  }
}

### Creating Private Route Table
resource "aws_default_route_table" "private_rt" {
  vpc_id = aws_vpc.sdm_k8s_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.sdm_k8s_nat.id
  }

  tags = {
    Name = "SDM k8s Private RT"
  }
}

### Creating Public Route Table Associations
resource "aws_route_table_association" "public_rt_asso_1" {
  count = length(var.var.public_subnets)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

### Creating Private Route Table Associations
resource "aws_route_table_association" "private_rt_asso_2" {
  count = length(var.var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = aws_route_table.private_rt.id
}