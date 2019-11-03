/*====
VPC's Default Security Group
======*/
resource "aws_security_group" "default" {
  name = "${var.environment}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id = var.vpc_id
  //depends_on  = [data.terraform_remote_state.remote.outputs.network]

  ingress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    self = true
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    self = "true"
  }

  tags = {
    Environment = var.environment
  }
}

/* Security Group for ECS */
resource "aws_security_group" "ecs_service" {
  vpc_id = var.vpc_id
  name = "${var.environment}-ecs-service-sg"
  description = "Allow egress from container"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-ecs-service-sg"
    Environment = var.environment
  }
}

/* security group for ALB */
resource "aws_security_group" "web_inbound_sg" {
  name = "${var.environment}-web-inbound-sg"
  description = "Allow HTTP from Anywhere into ALB"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-web-inbound-sg"
  }
}

/* Security Group for resources that want to access the Database */
resource "aws_security_group" "db_access_sg" {
  vpc_id = var.vpc_id
  name = "${var.environment}-db-access-sg"
  description = "Allow access to RDS"
  tags = {
    Name = "${var.environment}-db-access-sg"
    Environment = var.environment
  }
}
