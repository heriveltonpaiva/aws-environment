/*====
ECR repository to store our Docker images
AmazonEC2ContainerRegistryFullAccess
======*/
resource "aws_ecr_repository" "openjobs_app" {
  name = "${var.repository_name}"
} 