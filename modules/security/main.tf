# Tiered security groups: each tier only accepts traffic from the tier in front of it.
#
#   Internet --80/443--> ALB --app_port--> App --db_port--> DB

resource "aws_security_group" "alb" {
  name        = "${var.name}-alb"
  description = "Web tier: public HTTP/HTTPS into the Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = { Name = "${var.name}-alb-sg", Tier = "web" }
}

resource "aws_security_group" "app" {
  name        = "${var.name}-app"
  description = "App tier: only reachable from the ALB"
  vpc_id      = var.vpc_id

  tags = { Name = "${var.name}-app-sg", Tier = "app" }
}

resource "aws_security_group" "db" {
  name        = "${var.name}-db"
  description = "Data tier: only reachable from the app tier"
  vpc_id      = var.vpc_id

  tags = { Name = "${var.name}-db-sg", Tier = "db" }
}

# --- ALB ---------------------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTPS from the internet"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP from the internet (redirected to HTTPS by the listener)"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id            = aws_security_group.alb.id
  description                  = "Forward to the app tier only"
  referenced_security_group_id = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = var.app_port
  to_port                      = var.app_port
}

# --- App ---------------------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app.id
  description                  = "App traffic from the ALB"
  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "tcp"
  from_port                    = var.app_port
  to_port                      = var.app_port
}

resource "aws_vpc_security_group_egress_rule" "app_to_db" {
  security_group_id            = aws_security_group.app.id
  description                  = "Queries to the database tier"
  referenced_security_group_id = aws_security_group.db.id
  ip_protocol                  = "tcp"
  from_port                    = var.db_port
  to_port                      = var.db_port
}

resource "aws_vpc_security_group_egress_rule" "app_https_out" {
  security_group_id = aws_security_group.app.id
  description       = "HTTPS out for package updates and AWS APIs (via NAT or VPC endpoints)"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

# --- DB ----------------------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id            = aws_security_group.db.id
  description                  = "Database connections from the app tier"
  referenced_security_group_id = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = var.db_port
  to_port                      = var.db_port
}
# No egress rules on the DB tier: it never initiates connections.
