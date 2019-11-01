/**
resource "aws_instance" "hpaiva-ec2" {
  ami           = var.amis[var.region]
  instance_type = "t2.micro"
  depends_on    = [aws_s3_bucket.hpaiva-bucket]
  
  provisioner "local-exec" {
    command = "echo ${aws_instance.hpaiva-ec2.public_ip} > ip_address.txt"
  }
}
*/

/*====
ECS cluster
AmazonECS_FullAccess
======*/
resource "aws_ecs_cluster" "cluster" {
  name = "${var.environment}-ecs-cluster"
} 

/* Security Group for ECS */
resource "aws_security_group" "ecs_service" {
  vpc_id      = "${aws_vpc.vpc.id}"
  name        = "${var.environment}-ecs-service-sg"
  description = "Allow egress from container"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-ecs-service-sg"
    Environment = "${var.environment}"
  }
}

/* Simply specify the family to find the latest ACTIVE revision in that family */
data "aws_ecs_task_definition" "web" {
  task_definition = "${aws_ecs_task_definition.web.family}"
  depends_on = [ "aws_ecs_task_definition.web" ]
}

resource "aws_ecs_service" "web" {
  name            = "${var.environment}-web"
  task_definition = "${aws_ecs_task_definition.web.family}:${max("${aws_ecs_task_definition.web.revision}", "${data.aws_ecs_task_definition.web.revision}")}"
  desired_count   = 2
  launch_type     = "FARGATE"
  cluster =       "${aws_ecs_cluster.cluster.id}"
  //depends_on      = ["aws_iam_role_policy.ecs_service_role_policy"]

  network_configuration {
    security_groups = ["${aws_security_group.default.id}", "${aws_security_group.ecs_service.id}"]
    subnets = ["${element(aws_subnet.public_subnet.*.id, 0)}", "${element(aws_subnet.public_subnet.*.id, 1)}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    container_name   = "web"
    container_port   = "80"
  }

  //depends_on = ["aws_alb_target_group.alb_target_group"]
}
