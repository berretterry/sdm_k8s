###StrongDM Gateway
resource "aws_instance" "sdmqw_server" {
  count = length(var.public_subnets)
  instance_type = var.gateway_type
  ami = var.gateway_ami
  subnet_id = element(aws_subnet.public_subnet[0].id, count.index)
  security_groups = [aws_security_group.sdmgw_sg.id]
  key_name = aws_key_pair.ssh.key_name
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "10"
  }
  tags = {
    "Name" = "SDM GW Instance"
  }
  user_data = file("${path.module}/userdata/sdm_userdata.sh")
}

