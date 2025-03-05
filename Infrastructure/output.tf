output "ssh_private_key_pem" {
  description = "ssh private key"
  value = tls_private_key.ssh.private_key_pem
  sensitive = true
}

output "ssh_public_key_pem" {
  description = "ssh public key"
  value = tls_private_key.ssh.public_key_pem
  sensitive = true
}

output "nat_gateway_ip" {
  description = "NAT Gateway public IP"
  value = aws_eip.nat_eip.public_ip
}

output "app_private_ip" {
  description = "app server private ip"
  value = aws_instance.app_server.private_ip
}

output "web_private_ip" {
  description = "web server private ip"
  value = aws_instance.web_server.private_ip
}

output "sdmgw_private_ip" {
  description = "StrongDM Gateway Private IP"
  value = aws_instance.sdmqw_server.private_ip
}

output "sdmgw_public_ip" {
  description = "StrongDM Gateway Public IP"
  value = aws_instance.sdmqw_server.public_ip
}

output "jump_public_ip" {
  description = "Jump Instance Public IP"
  value = aws_instance.jump_server.public_ip
}

output "db_instance_address" {
  description = "RDS Instance Address"
  value = aws_db_instance.sdm_database.address
}

output "mysql_username" {
  value = var.mysql_username
  sensitive = true
}

output "mysql_pass" {
  value = var.mysql_pass
  sensitive = true
}

output "app_relay_private_ip" {
  description = "app relay private ip"
  value = aws_instance.app_relay.private_ip
}

output "db_relay_private_ip" {
  description = "db relay private ip"
  value = aws_instance.db_relay.private_ip
}