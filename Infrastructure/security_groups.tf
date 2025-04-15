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

resource "aws_vpc_security_group_ingress_rule" "sdmgw_port" {
  security_group_id = aws_security_group.sdmgw_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 5000
  ip_protocol = "tcp"
  to_port = 5000
}

resource "aws_vpc_security_group_ingress_rule" "sdmgw_port" {
  security_group_id = aws_security_group.sdmgw_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

### Creating Security Group for EKS
#resource "aws_security_group" "eks_sg" {
#  name        = "eks_sg"
#  description = "EKS Security Group"
#  vpc_id      = aws_vpc.sdm_k8s_vpc.id
#
#  tags = {
#    Name = "k8s sg"
#  }
#}

#resource "aws_vpc_security_group_egress_rule" "eks_egress" {
#  security_group_id = aws_security_group.eks_sg.id
#  cidr_ipv4 = "0.0.0.0/0"
#  from_port   = 0
#  to_port     = 0
#  ip_protocol    = "-1"
#}

#resource "aws_vpc_security_group_ingress_rule" "gw_to_eks" {
#  security_group_id = aws_security_group.eks_sg.id
#  referenced_security_group_id = aws_security_group.sdmgw_sg.id
#  from_port = 443
#  ip_protocol = "tcp"
#  to_port = 443
#}
