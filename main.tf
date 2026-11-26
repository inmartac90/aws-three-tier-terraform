locals {
  name = "${var.project_name}-${var.environment}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "network" {
  source = "./modules/network"

  name                     = local.name
  vpc_cidr                 = var.vpc_cidr
  azs                      = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  enable_nat_gateway       = var.enable_nat_gateway
  single_nat_gateway       = var.single_nat_gateway
  enable_flow_logs         = var.enable_flow_logs
  flow_logs_retention_days = var.flow_logs_retention_days
}

module "security" {
  source = "./modules/security"

  name     = local.name
  vpc_id   = module.network.vpc_id
  app_port = var.app_port
  db_port  = var.db_port
}

# Phase 2: compute (ALB + Auto Scaling Group)  -> modules/compute
# Phase 3: data (RDS Multi-AZ + Secrets Manager) -> modules/data
# Phase 4: observability (CloudWatch dashboard, alarms, SNS) -> modules/observability
