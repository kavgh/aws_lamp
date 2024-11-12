locals {
  name = "${var.project}-${var.env}-rds"

  tags = merge(var.tags, { Service = "rds" })
}

resource "aws_iam_role" "this" {
  name               = "${local.name}-monitoring-role"
  description        = "Allow enhanced monitoring to the RDS instance"
  assume_role_policy = data.aws_iam_policy_document.this.json

  tags = merge(local.tags, { Resource = "iam-role" })
}

data "aws_iam_policy_document" "this" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_security_group" "this" {
  name        = "${local.name}-sg"
  description = "Allow connection to the DB"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, { Resource = "security-group" })
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  count = length(var.rsg_ids)

  description                  = "Allow inbound traffic to the DB instance from EC2"
  from_port                    = var.port
  to_port                      = var.port
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.rsg_ids[count.index]
  security_group_id            = aws_security_group.this.id

  tags = merge(local.tags, { Resource = "isg-rule" })
}

resource "aws_db_subnet_group" "this" {
  name        = "${local.name}-sub-grp"
  description = "Subnet group for association with the DB instance"
  subnet_ids  = var.subnet_ids

  tags = merge(local.tags, { Resource = "rds-sub-grp" })
}

resource "aws_db_parameter_group" "this" {
  name        = "${local.name}-param-grp"
  description = "Parameter group for association with DB instance"
  family      = var.family

  tags = merge(local.tags, { Resource = "rds-param-grp " })
}

resource "aws_db_instance" "this" {
  identifier                      = local.name
  instance_class                  = var.instance_class
  allocated_storage               = var.allocated_storage
  max_allocated_storage           = var.max_allocated_storage
  port                            = var.port
  backup_retention_period         = 7
  engine_version                  = var.db_version
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.this.arn

  parameter_group_name = aws_db_parameter_group.this.id
  db_subnet_group_name = aws_db_subnet_group.this.id
  snapshot_identifier  = data.aws_db_snapshot.this.id

  vpc_security_group_ids = flatten([var.sg_ids, [aws_security_group.this.id]])

  tags = merge(local.tags, { Resource = "rds-instance" })
}

data "aws_db_snapshot" "this" {
  db_snapshot_identifier = var.snapshot_identifier
}
