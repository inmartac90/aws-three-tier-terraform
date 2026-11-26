output "alb_sg_id" {
  description = "Security group for the Application Load Balancer."
  value       = aws_security_group.alb.id
}

output "app_sg_id" {
  description = "Security group for the application tier."
  value       = aws_security_group.app.id
}

output "db_sg_id" {
  description = "Security group for the database tier."
  value       = aws_security_group.db.id
}
