variable "name" {
  description = "Name prefix for security groups."
  type        = string
}

variable "vpc_id" {
  description = "VPC to create the security groups in."
  type        = string
}

variable "app_port" {
  description = "Port the application tier listens on."
  type        = number
}

variable "db_port" {
  description = "Port the database tier listens on."
  type        = number
}
