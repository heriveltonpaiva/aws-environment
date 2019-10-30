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
