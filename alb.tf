#https://thecode.pub/easy-deploy-your-docker-applications-to-aws-using-ecs-and-fargate-a988a1cc842f

resource "random_string" "random" {
  length = 5
}

resource "aws_alb_target_group" "alb_target_group" {
  name     = "prod-alb-target-group-231321"#${random_string.random}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }
}

/* security group for ALB */
resource "aws_security_group" "web_inbound_sg" {
  name        = "${var.environment}-web-inbound-sg"
  description = "Allow HTTP from Anywhere into ALB"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-web-inbound-sg"
  }
}

resource "aws_alb" "alb_openjobs" {
  name            = "${var.environment}-alb-openjobs"
  subnets         = ["${element(aws_subnet.public_subnet.*.id, 0)}", "${element(aws_subnet.public_subnet.*.id, 1)}"]
  security_groups = ["${aws_security_group.db_access_sg.id}", "${aws_security_group.web_inbound_sg.id}"]

  tags = {
    Name        = "${var.environment}-alb-openjobs"
    Environment = "${var.environment}"
  }
}

resource "aws_alb_listener" "openjobs" {
  load_balancer_arn = "${aws_alb.alb_openjobs.arn}"
  port              = "80"
  protocol          = "HTTP"
  depends_on        = ["aws_alb_target_group.alb_target_group"]

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    type             = "forward"
  }
}