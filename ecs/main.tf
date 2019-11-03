/*====
ECS cluster
AmazonECS_FullAccess
======*/
resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name
}

/* Simply specify the family to find the latest ACTIVE revision in that family
data "aws_ecs_task_definition" "web" {
  task_definition = "${aws_ecs_task_definition.web.family}"
  depends_on = [
    "aws_ecs_task_definition.web"]
}

resource "aws_ecs_service" "web" {
  name = var.ecs_service_name
  task_definition = "${aws_ecs_task_definition.web.family}:${max("${aws_ecs_task_definition.web.revision}", "${data.aws_ecs_task_definition.web.revision}")}"
  desired_count = 2
  launch_type = "FARGATE"
  cluster = "${aws_ecs_cluster.cluster.id}"

  network_configuration {
    security_groups = [
      "${aws_security_group.default.id}",
      "${aws_security_group.ecs_service.id}"]
    subnets = [
      "${element(aws_subnet.public_subnet.*.id, 0)}",
      "${element(aws_subnet.public_subnet.*.id, 1)}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    container_name = "web"
    container_port = "80"
  }

}
*/