/*====
ECS cluster
AmazonECS_FullAccess
======*/
resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name
}

/* Simply specify the family to find the latest ACTIVE revision in that family */
data "aws_ecs_task_definition" "web" {
  task_definition = aws_ecs_task_definition.web.family
  depends_on = [
    "aws_ecs_task_definition.web"]
}

resource "aws_ecs_service" "web" {
  name = var.ecs_service_name
  task_definition = "${aws_ecs_task_definition.web.family}:${max("${aws_ecs_task_definition.web.revision}", "${data.aws_ecs_task_definition.web.revision}")}"
  desired_count = 2
  launch_type = "FARGATE"
  cluster = aws_ecs_cluster.cluster.id

  network_configuration {
    security_groups = [
      var.security_group.default.id,
      var.security_group.ecs_service.id,
      var.security_group.alb_sg.id]
    subnets = [
      element(var.public_subnet.*.id, 0),
      element(var.public_subnet.*.id, 1)]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group.arn
    container_name = "web"
    container_port = "80"
  }

  depends_on = [var.target_group]
}
