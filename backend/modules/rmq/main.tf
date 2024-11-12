locals {
  name = "${var.project}-${var.env}-broker"
  port = 5671
  tags = merge(var.tags, { Service = "message-queue" })
}

resource "aws_security_group" "this" {
  name        = "${local.name}-sg"
  description = "Allow connection to the ${var.engine}"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, { Resource = "security-group" })
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  count = length(var.rsg_ids)

  description                  = "Allow inbound ${var.engine} traffic from EC2 instances"
  from_port                    = local.port
  to_port                      = local.port
  ip_protocol                  = "tcp"
  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = var.rsg_ids[count.index]

  tags = merge(local.tags, { Resource = "isg-rule" })
}

resource "random_password" "this" {
  length  = 20
  special = false
}

resource "aws_mq_broker" "this" {
  broker_name                = "${local.name}-mq"
  engine_type                = var.engine
  engine_version             = var.engine_version
  host_instance_type         = var.instance_type
  auto_minor_version_upgrade = true
  deployment_mode            = "SINGLE_INSTANCE"
  publicly_accessible        = false
  security_groups            = flatten([var.sg_ids, [aws_security_group.this.id]])
  subnet_ids                 = [var.subnet_ids[0]]


  user {
    username = var.username
    password = random_password.this.result
  }

  logs {
    general = true
  }

  tags = merge(local.tags, { Resource = "mq-instance" })
}