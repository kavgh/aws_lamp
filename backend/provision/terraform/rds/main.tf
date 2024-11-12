locals {
  name = "${var.project}-${var.env}-rds"

  tags = merge(var.tags, { Service = "rds" })
}

resource "random_password" "this" {
  length = 20
}

resource "aws_security_group" "this" {
  name        = "${local.name}-sg"
  description = "Allow connection to ${var.engine} db"
  vpc_id = var.vpc_id

  tags = merge(local.tags, { Resource = "security-group" })
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  description       = "Allow inbound traffic to ${var.engine} db"
  from_port         = var.port
  to_port           = var.port
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.this.id

  tags = merge(local.tags, { Resource = "sgi-rule" })
}

resource "aws_vpc_security_group_egress_rule" "this" {
  ip_protocol = -1
  security_group_id = aws_security_group.this.id
  cidr_ipv4 = "0.0.0.0/0"
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.9.0"

  identifier              = local.name
  backup_retention_period = 7

  engine                = var.engine
  engine_version        = var.db_version
  instance_class        = var.instance_class
  storage_type           = "gp2"
  allocated_storage     = 20
  max_allocated_storage = 60

  db_name                = var.db_name
  username               = var.username
  password               = random_password.this.result
  port                   = var.port
  vpc_security_group_ids = [aws_security_group.this.id]

  db_subnet_group_name        = "${local.name}-sub-grp"
  db_subnet_group_description = "The RDS subnet group for the ${var.project} project"
  subnet_ids = var.subnet_ids

  create_db_subnet_group    = true
  iam_database_authentication_enabled = false
  create_db_option_group    = false
  create_db_parameter_group = false
  manage_master_user_password = false

  db_instance_tags     = merge(local.tags, { Resource = "db" })
  db_subnet_group_tags = merge(local.tags, { Resource = "subnet-group" })
}