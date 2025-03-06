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
resource "aws_subnet" "web_tier_subnet" {
  vpc_id                  = aws_vpc.sdm_k8s_vpc.id
  cidr_block              = var.web_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true


  tags = {
    Name = "Web Tier Public Subnet"
  }
}

### Creating Private Subnet
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets)
  vpc_id                  = aws_vpc.sdm_k8s_vpc.id
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.aws_azs, count.index)
  map_public_ip_on_launch = false


  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_db_subnet_group" "private_subnet_group" {
  name = "private_subnet_group"
  subnet_ids = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]

  tags = {
    Name = "private subnet group"
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
  domain = "vpc"

  tags = {
    Name = "NAT EIP"
  }
}

### Creating NAT Gateway for App Subnet Internet Access
resource "aws_nat_gateway" "sdm_k8s_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  depends_on = [aws_internet_gateway.sdm_challenge_igw]

  tags = {
    Name = "SDM Challenge NAT"
  }
}

### Creating Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.sdm_challenge_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sdm_challenge_igw.id
  }

  tags = {
    Name = "SDM Challenge Public RT"
  }
}

### Creating Private Route Table
resource "aws_default_route_table" "default_rt" {
  default_route_table_id = aws_vpc.sdm_challenge_vpc.default_route_table_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.sdm_challenge_nat.id
  }

  tags = {
    Name = "SDM Challenge Default RT"
  }
}

### Creating Public Route Table Associations
resource "aws_route_table_association" "public_rt_asso_1" {
  subnet_id      = aws_subnet.web_tier_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

### Creating Private Route Table Associations
resource "aws_route_table_association" "private_rt_asso_1" {
  subnet_id      = aws_subnet.app_tier_subnet.id
  route_table_id = aws_default_route_table.default_rt.id
}

### Creating Private Route Table Associations
resource "aws_route_table_association" "private_rt_asso_2" {
  count = length(var.db_subnet_cidr)
  subnet_id      = element(aws_subnet.data_tier_subnet[*].id, count.index)
  route_table_id = aws_default_route_table.default_rt.id
}