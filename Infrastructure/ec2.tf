###Web Server
resource "aws_instance" "web_server" {
  instance_type = var.server_type
  ami = var.server_ami
  subnet_id = aws_subnet.web_tier_subnet.id
  security_groups = [aws_security_group.web_sg.id]
  key_name = aws_key_pair.ssh.key_name
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "10"
  }
  tags = {
    "Name" = "Web Tier Instance"
  }
}


###App Server
resource "aws_instance" "app_server" {
  instance_type = var.server_type
  ami = var.server_ami
  subnet_id = aws_subnet.app_tier_subnet.id
  security_groups = [aws_security_group.app_sg.id]
  key_name = aws_key_pair.ssh.key_name
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "10"
  }
  tags = {
    "Name" = "App Tier Instance"
  }
}
###StrongDM Gateway
resource "aws_instance" "sdmqw_server" {
  instance_type = var.gateway_type
  ami = var.gateway_ami
  subnet_id = aws_subnet.web_tier_subnet.id
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

###StrongDM Relays
resource "aws_instance" "app_relay" {
  instance_type = var.server_type
  ami = var.gateway_ami
  subnet_id = aws_subnet.app_tier_subnet.id
  security_groups = [aws_security_group.app_relay_sg.id]
  key_name = aws_key_pair.ssh.key_name
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "10"
  }
  tags = {
    "Name" = "SDM App Relay Instance"
  }
  user_data = file("${path.module}/userdata/sdm_userdata.sh")
}

resource "aws_instance" "db_relay" {
  instance_type = var.server_type
  ami = var.gateway_ami
  subnet_id = aws_subnet.data_tier_subnet[0].id
  security_groups = [aws_security_group.db_relay_sg.id]
  key_name = aws_key_pair.ssh.key_name
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "10"
  }
  tags = {
    "Name" = "SDM DB Relay Instance"
  }
  user_data = file("${path.module}/userdata/sdm_userdata.sh")
}

# Create Jump Server
resource "aws_instance" "jump_server" {
  instance_type = var.server_type
  ami = var.server_ami
  subnet_id = aws_subnet.web_tier_subnet.id
  security_groups = [aws_security_group.jump_sg.id]
  key_name = aws_key_pair.ssh.key_name
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "10"
  }
  tags = {
    "Name" = "Jump Instance"
  }
}