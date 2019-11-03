output "default" {
  value = aws_security_group.default
}

output "ecs_service" {
  value = aws_security_group.ecs_service
}

output "alb_sg" {
  value = aws_security_group.web_inbound_sg
}

output "rds_sg" {
  value = aws_security_group.db_access_sg
}