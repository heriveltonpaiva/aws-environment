variable "ecs_cluster_name" {
  default = "prod-ecs-cluster"
}

variable "ecs_service_name" {
  default = "aws-project"
}

variable "environment" {}

variable "ecr" {}

variable "public_subnet" {}

variable "private_subnet" {}

variable "target_group" {}

variable "security_group" {}