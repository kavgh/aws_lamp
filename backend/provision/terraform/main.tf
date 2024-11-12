locals {
  credentials_files = ["~/.aws/credentials"]
  config_files      = ["~/.aws/config"]
  profile           = "default"
  pkey              = file("~/.ssh/aws_ec2.pub")
}

provider "aws" {
  shared_config_files      = local.config_files
  shared_credentials_files = local.credentials_files
  profile                  = local.profile
}

resource "aws_key_pair" "this" {
  key_name   = "ssh-pub-key"
  public_key = local.pkey
}

module "rds" {
  source = "./rds"
  
  vpc_id = data.aws_vpc.this.id
  subnet_ids = data.aws_subnets.this.ids
}

resource "aws_default_vpc" "this" {}

data "aws_vpc" "this" {
  default = true
}

data "aws_subnets" "this" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name = "tmp"
  assume_role_policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_instance_profile" "this" {
  name = "tmp"
  role = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "this" {
  role = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"
}