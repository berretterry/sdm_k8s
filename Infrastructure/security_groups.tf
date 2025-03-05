### Creating Security Group for SSH
resource "aws_security_group" "jump_sg" {
  name        = "ssh_sg"
  description = "SSH Security Group"
  vpc_id      = aws_vpc.sdm_challenge_vpc.id

  tags = {
    Name = "jump sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "jump_egress" {
  security_group_id = aws_security_group.jump_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  ip_protocol    = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "jump_ssh" {
  security_group_id = aws_security_group.jump_sg.id
  cidr_ipv4 = var.access_cidr
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

#Web Security Group
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Web Security Group"
  vpc_id      = aws_vpc.sdm_challenge_vpc.id

  tags = {
    Name = "app ssh sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "web_egress" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  ip_protocol    = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "gw_to_web_ssh" {
  security_group_id = aws_security_group.web_sg.id
  referenced_security_group_id = aws_security_group.sdmgw_sg.id
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "jump_to_web_ssh" {
  security_group_id = aws_security_group.web_sg.id
  referenced_security_group_id = aws_security_group.jump_sg.id
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "web_traffic" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
}

#App Security Group
resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "App Security Group"
  vpc_id      = aws_vpc.sdm_challenge_vpc.id

  tags = {
    Name = "app ssh sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "app_egress" {
  security_group_id = aws_security_group.app_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  ip_protocol    = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "jump_to_app_ssh" {
  security_group_id = aws_security_group.app_sg.id
  referenced_security_group_id = aws_security_group.jump_sg.id
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "rely_to_app_ssh" {
  security_group_id = aws_security_group.app_sg.id
  referenced_security_group_id = aws_security_group.app_relay_sg.id
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "web_to_app_web" {
  security_group_id = aws_security_group.app_sg.id
  referenced_security_group_id = aws_security_group.web_sg.id
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
}

### Creating SDM GW Security Group
resource "aws_security_group" "sdmgw_sg" {
  name = "sdmgw_sg"
  description = "StrongDM Gateway Security Group"
  vpc_id = aws_vpc.sdm_challenge_vpc.id

  tags = {
    Name = "sdm gw sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "sdmgw_egress" {
  security_group_id = aws_security_group.sdmgw_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  ip_protocol    = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "jump_to_sdmgw_ssh" {
  security_group_id = aws_security_group.sdmgw_sg.id
  referenced_security_group_id = aws_security_group.jump_sg.id
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "sdmgw_port" {
  security_group_id = aws_security_group.sdmgw_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 5000
  ip_protocol = "tcp"
  to_port = 5000
}

### Creating Security Group for Data Tier
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Database Security Group"
  vpc_id      = aws_vpc.sdm_challenge_vpc.id

  tags = {
    Name = "db sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "db_egress" {
  security_group_id = aws_security_group.db_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  ip_protocol    = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "app_to_db_web" {
  security_group_id = aws_security_group.db_sg.id
  referenced_security_group_id = aws_security_group.app_sg.id
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "app_to_db_mysql" {
  security_group_id = aws_security_group.db_sg.id
  referenced_security_group_id = aws_security_group.app_sg.id
  from_port = 3306
  ip_protocol = "tcp"
  to_port = 3306
}

resource "aws_vpc_security_group_ingress_rule" "mysql_relay_to_db" {
  security_group_id = aws_security_group.db_sg.id
  referenced_security_group_id = aws_security_group.db_relay_sg.id
  from_port = 3306
  ip_protocol = "tcp"
  to_port = 3306
}

### Creating Security Group for App Relay
resource "aws_security_group" "app_relay_sg" {
  name        = "app_relay_sg"
  description = "App Relay Security Group"
  vpc_id      = aws_vpc.sdm_challenge_vpc.id

  tags = {
    Name = "App Relay sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "app_relay_egress" {
  security_group_id = aws_security_group.app_relay_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  ip_protocol    = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "app_relay_ssh" {
  security_group_id = aws_security_group.app_relay_sg.id
  referenced_security_group_id = aws_security_group.jump_sg.id
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

### Creating Security Group for DB Relay
resource "aws_security_group" "db_relay_sg" {
  name        = "db_relay_sg"
  description = "DB Relay Security Group"
  vpc_id      = aws_vpc.sdm_challenge_vpc.id

  tags = {
    Name = "DB Relay sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "DB_relay_egress" {
  security_group_id = aws_security_group.db_relay_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  ip_protocol    = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "db_relay_ssh" {
  security_group_id = aws_security_group.db_relay_sg.id
  referenced_security_group_id = aws_security_group.jump_sg.id
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}