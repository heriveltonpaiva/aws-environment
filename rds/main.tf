/*====
RDS
======*/

/* subnet used by rds
resource "aws_db_subnet_group" "default" {
  name        = "${var.environment}-database-subnet-group"
  description = "Terraform example RDS subnet group"
  subnet_ids = ["${element(aws_subnet.public_subnet.*.id, 0)}", "${element(aws_subnet.public_subnet.*.id, 1)}"]
 }

resource "aws_security_group" "rds_sg" {
  name = "${var.environment}-rds-sg"
  description = "${var.environment} Security Group"
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name = "${var.environment}-rds-sg"
    Environment =  "${var.environment}"
  }

  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      self = true
  }

  ingress {
      from_port = 5432
      to_port   = 5432
      protocol  = "tcp"
      security_groups = [aws_security_group.db_access_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds" {
  identifier             = "${var.environment}-database"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "9.6.6"
  instance_class         = "${var.database["instance"]}"
 // multi_az               = "${var.multi_az}"
  name                   = "${var.database["name"]}"
  username               = "${var.database["username"]}"
  password               = "${var.database["password"]}"
  db_subnet_group_name   = "${aws_db_subnet_group.default.id}"
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot    = true
//  snapshot_identifier    = "rds-${var.environment}-snapshot"
  tags = {
    Environment = "${var.environment}"
  }
}
*/