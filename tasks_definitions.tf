resource "aws_cloudwatch_log_group" "openjobs" {
  name = "ecs"

  tags = {
    Environment = "production"
    Application = "WEB"
  }
}

/* the task definition for the web service */
data "template_file" "web_task" {
  template = "${file("${path.module}/tasks/web_task_definition.json")}"

  vars = {
    image           = "${aws_ecr_repository.openjobs_app.repository_url}"
    secret_key_base = "1232"
    database_url    = "postgresql://${var.database["username"]}:${var.database["password"]}@${aws_db_instance.rds.endpoint}:5432/${var.database["name"]}?encoding=utf8&pool=40"
    log_group       = "${aws_cloudwatch_log_group.openjobs.name}"
  }
}

resource "aws_ecs_task_definition" "web" {
  family                   = "${var.environment}_web"
  container_definitions    = "${data.template_file.web_task.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  //execution_role_arn       = "${aws_iam_role.ecs_execution_role.arn}"
  //task_role_arn            = "${aws_iam_role.ecs_execution_role.arn}"
}

/* the task definition for the db migration */
data "template_file" "db_migrate_task" {
  template = "${file("${path.module}/tasks/db_migrate_task_definition.json")}"

  vars = {
    image           = "${aws_ecr_repository.openjobs_app.repository_url}"
    secret_key_base = "12"
    database_url    = "postgresql://${var.database["username"]}:${var.database["password"]}@${aws_db_instance.rds.endpoint}:5432/${var.database["name"]}?encoding=utf8&pool=40"
    log_group       = "openjobs"
  }
}

resource "aws_ecs_task_definition" "db_migrate" {
  family                   = "${var.environment}_db_migrate"
  container_definitions    = "${data.template_file.db_migrate_task.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  //execution_role_arn       = "${aws_iam_role.ecs_execution_role.arn}"
  //task_role_arn            = "${aws_iam_role.ecs_execution_role.arn}"
}