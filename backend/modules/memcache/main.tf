resource "aws_elasticache_parameter_group" "this" {
  name = "${local.name}-pg"
  description = "Parameter group for the ${local.name}-cluster elasicache instance"
  family = var.family

  tags = merge(local.tags, { Resource = "ecache-param-gr" })
}

resource "aws_elasticache_subnet_group" "this" {
  name = "${local.name}-sub-gr"
  description = "The subnet group for the ${var.engine} instance"
  subnet_ids = var.subnet_ids

  tags = merge(local.tags, { Resource = "elasticache-sub-gr"})
}

resource "aws_elasticache_cluster" "this" {
  cluster_id = "${local.name}-cluster"
  engine = var.engine
  node_type = "cache.t3.micro"
  num_cache_nodes = 1
  parameter_group_name = aws_elasticache_parameter_group.this.id
    engine_version = "1.6.22"
    network_type = "ipv4"
    notification_topic_arn = var.sns_arn
    security_group_ids = flatten([[aws_security_group.this.id], var.sg_ids])
    subnet_group_name = aws_elasticache_subnet_group.this.id
    transit_encryption_enabled = false
    port = var.port

    tags = merge(local.tags, { Resource = "ecache-cluster"})
}

locals {
  name = "${var.project}-${var.env}-${var.engine}"

  tags = merge(var.tags, { Service = "elasticache" })
}

resource "aws_security_group" "this" {
  name        = "${local.name}-sg"
  description = "Allow connection to the ${var.engine} instance"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, { Resource = "security-group" })
}

resource "aws_vpc_security_group_ingress_rule" "this" {
count = length(var.rsg_ids)

  description                  = "Allow inbound traffic to the ${var.engine} instance from EC2"
  from_port                    = var.port
  to_port                      = var.port
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.rsg_ids[count.index]
  security_group_id            = aws_security_group.this.id

  tags = merge(local.tags, { Resource = "isg-rule" })
}