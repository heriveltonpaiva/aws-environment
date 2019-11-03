/*====
ECR repository to store our Docker images
AmazonEC2ContainerRegistryFullAccess
======*/
resource "aws_ecr_repository" "repository" {
  name = "my-repository-${var.environment}"
}