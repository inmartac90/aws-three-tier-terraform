variable "name" {
  description = "Name prefix for network resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "Availability Zones to place subnets in."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Create NAT Gateway(s) for private app subnets."
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Share one NAT Gateway across all AZs."
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs to CloudWatch Logs."
  type        = bool
  default     = false
}

variable "flow_logs_retention_days" {
  description = "Retention in days for the flow logs log group."
  type        = number
  default     = 14
}
