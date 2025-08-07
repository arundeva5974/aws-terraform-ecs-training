output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "ID of the ECS security group"
  value       = aws_security_group.ecs.id
}

output "ec2_ecs_security_group_id" {
  description = "ID of the EC2 ECS security group"
  value       = aws_security_group.ec2_ecs.id
}
