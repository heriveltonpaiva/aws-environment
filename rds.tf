/*====
RDS
======*/

/** 
resource "aws_subnet" "rds" {
  count                   = "${length(var.availability_zones)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.${length(var.availability_zones) + count.index}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${element(var.availability_zones, count.index)}"
  tags = {
    Name = "rds-${element(var.availability_zones, count.index)}"
  }
}
*/

/* subnet used by rds */
resource "aws_db_subnet_group" "default" {
  name        = "${var.environment}-database-subnet-group"
  description = "Terraform example RDS subnet group"
  subnet_ids = ["${element(aws_subnet.public_subnet.*.id, 0)}", "${element(aws_subnet.public_subnet.*.id, 1)}"]
 }

/* Security Group for resources that want to access the Database */
resource "aws_security_group" "db_access_sg" {
  vpc_id      = "${aws_vpc.vpc.id}"
  name        = "${var.environment}-db-access-sg"
  description = "Allow access to RDS"
  depends_on  = ["aws_vpc.vpc"]
  tags = {
    Name        = "${var.environment}-db-access-sg"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "rds_sg" {
  name = "${var.environment}-rds-sg"
  description = "${var.environment} Security Group"
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name = "${var.environment}-rds-sg"
    Environment =  "${var.environment}"
  }

  // allows traffic from the SG itself
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      self = true
  }

  //allow traffic for TCP 5432
  ingress {
      from_port = 5432
      to_port   = 5432
      protocol  = "tcp"
      security_groups = ["${aws_security_group.db_access_sg.id}"]
  }

  // outbound internet access
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