output "vpc_id" {
  description = "ID of the VPC."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnets (web tier / ALB)."
  value       = module.network.public_subnet_ids
}

output "app_subnet_ids" {
  description = "Private subnets for the application tier."
  value       = module.network.app_subnet_ids
}

output "db_subnet_ids" {
  description = "Isolated subnets for the database tier."
  value       = module.network.db_subnet_ids
}

output "security_group_ids" {
  description = "Security groups per tier."
  value = {
    alb = module.security.alb_sg_id
    app = module.security.app_sg_id
    db  = module.security.db_sg_id
  }
}
