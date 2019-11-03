#CloudWatchLogsFullAccess
resource "aws_cloudwatch_log_group" "openjobs" {
  name = "ecs"
  tags = {
    Environment = "prod"
    Application = "WEB"
  }
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}
/* the task definition for the web service
data "template_file" "web_task" {
  template = "${file("${path.module}/web_task_definition.json")}"

  vars = {
    image           = "${aws_ecr_repository.my-repository.repository_url}"
    secret_key_base = "1232"
    #database_url    = "postgresql://${var.database["username"]}:${var.database["password"]}@${aws_db_instance.rds.endpoint}:5432/${var.database["name"]}?encoding=utf8&pool=40"
    log_group       = "${aws_cloudwatch_log_group.openjobs.name}"
  }
}
resource "aws_ecs_task_definition" "web" {
  family                   = "prod_web"
  container_definitions    = "${data.template_file.web_task.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "${data.aws_iam_role.ecs_task_execution_role.arn}"
}*/
