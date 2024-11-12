locals {
  name          = "${var.project}-${var.env}-vpc"
  noz           = length(data.aws_availability_zones.this.names)
  cidr_subnets  = cidrsubnets(var.ipv4_cidr, local.noz, local.noz, local.noz, local.noz)
  ingress_ports = { ssh = 22, http = 8080 }

  tags = merge(var.tags, { Service = "vpc" })
}

data "aws_availability_zones" "this" {
  state = "available"
}

resource "aws_security_group" "out" {
  name        = "${local.name}-out-sg"
  description = "Security group for outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = merge(local.tags, { Resource = "security-group" })
}

resource "aws_security_group" "this" {
  for_each = local.ingress_ports

  name        = "${local.name}-${each.key}-sg"
  description = "Security group for inbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = merge(local.tags, { Resource = "security-group" })
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = local.ingress_ports

  description       = "Allow ${each.key} connection to the instance"
  security_group_id = aws_security_group.this[each.key].id
  from_port         = each.value
  to_port           = each.value
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = merge(local.tags, { Resource = "sgi-rule" })
}

resource "aws_vpc_security_group_egress_rule" "out" {
  description       = "Allow outbound traffic to anywhere"
  security_group_id = aws_security_group.out.id
  ip_protocol       = -1
  cidr_ipv4         = "0.0.0.0/0"

  tags = merge(local.tags, { Resource = "sge-rule" })
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.13.0"

  name            = local.name
  azs             = data.aws_availability_zones.this.names
  cidr            = var.ipv4_cidr
  public_subnets  = slice(local.cidr_subnets, 0, 2)
  private_subnets = slice(local.cidr_subnets, 2, length(local.cidr_subnets))

  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false
  manage_default_vpc            = false

  igw_tags                 = merge(local.tags, { Resource = "igw" })
  private_route_table_tags = merge(local.tags, { Resource = "private-rtb" })
  private_subnet_tags      = merge(local.tags, { Resource = "private-subnet" })
  public_route_table_tags  = merge(local.tags, { Resource = "public-rtb" })
  public_subnet_tags       = merge(local.tags, { Resource = "private-subnet" })
}