###Create ssh key

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name = "sdm_private_key"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "local_file" "sdm_public_key" {
  content = tls_private_key.ssh.private_key_openssh
  filename = "sdm_private_key.pem"
}

