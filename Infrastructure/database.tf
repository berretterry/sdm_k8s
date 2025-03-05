### Create RDS Database
resource "aws_db_instance" "sdm_database" {
  allocated_storage = 10
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"
  identifier = "sdmdatabase"
  username = var.mysql_username
  password = var.mysql_pass

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.data_tier_subnet_group.name

  #count = length(var.db_subnet_cidr)
  #db_subnet_group_name = element(aws_subnet.data_tier_subnet[*].name, count.index)

  skip_final_snapshot = true
}