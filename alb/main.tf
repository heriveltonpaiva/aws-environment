#https://thecode.pub/easy-deploy-your-docker-applications-to-aws-using-ecs-and-fargate-a988a1cc842f

resource "random_string" "random" {
  length = 5
}

resource "aws_alb_target_group" "alb_target_group" {
  name = "prod-alb-target-group"
  #${random_string.random}"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/actuator/health"
    unhealthy_threshold = "2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb" "alb_openjobs" {
  name            = "${var.environment}-alb-openjobs"
  subnets         = [element(var.public_subnet.*.id, 0), element(var.public_subnet.*.id, 1)]
  security_groups = [var.security_group.alb_sg.id]

  tags = {
    Name        = "${var.environment}-alb-openjobs"
    Environment = var.environment
  }
}

resource "aws_alb_listener" "openjobs" {
  load_balancer_arn = aws_alb.alb_openjobs.arn
  port              = "80"
  protocol          = "HTTP"
  depends_on        = ["aws_alb_target_group.alb_target_group"]

  default_action {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    type             = "forward"
  }
}
