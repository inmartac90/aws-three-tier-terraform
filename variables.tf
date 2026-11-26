variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix for all resources."
  type        = string
  default     = "three-tier"

  validation {
    condition     = can(regex("^[a-z0-9-]{3,20}$", var.project_name))
    error_message = "project_name must be 3-20 lowercase letters, numbers or hyphens."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging or prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "az_count" {
  description = "Number of Availability Zones to span (2 or 3)."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "az_count must be 2 or 3 for a highly available design."
  }
}

variable "enable_nat_gateway" {
  description = "Create NAT Gateway(s) for outbound internet from private subnets. Costs money: keep false unless needed."
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Use one shared NAT Gateway instead of one per AZ (cheaper, less resilient)."
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Send VPC Flow Logs to CloudWatch Logs (small ingestion cost)."
  type        = bool
  default     = false
}

variable "flow_logs_retention_days" {
  description = "Retention for the VPC Flow Logs log group."
  type        = number
  default     = 14
}

variable "app_port" {
  description = "Port the application tier listens on."
  type        = number
  default     = 8080
}

variable "db_port" {
  description = "Port the database tier listens on (3306 MySQL, 5432 PostgreSQL)."
  type        = number
  default     = 5432
}
