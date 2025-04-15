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

output "sdmgw_private_ip" {
  description = "StrongDM Gateway Private IP"
  value = aws_instance.sdmqw_server.private_ip
}

output "sdmgw_instance_id" {
  description = "StrongDM Gateway Public IP"
  value = aws_instance.sdmqw_server.id
}

output "sdmgw_public_ip" {
  description = "StrongDM Gateway Public IP"
  value = aws_instance.sdmqw_server.public_ip
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}