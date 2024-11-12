locals {
  service_permissions          = toset(["arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth", "arn:aws:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"])
  instance_profile_permissions = toset(["arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier", "arn:aws:iam::aws:policy/AWSElasticBeanstalkCustomPlatformforEC2Role", "arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk", "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkRoleSNS"])

  tags = merge(var.tags, { Service = "iam-role" })
}

resource "aws_iam_role" "service" {
  name               = "aws-elasticbeanstalk-service-role"
  description        = "The elasticbeanstalk role to associate with"
  assume_role_policy = data.aws_iam_policy_document.service.json

  tags = merge(local.tags, { Resource = "beanstalk-service" })
}

data "aws_iam_policy_document" "service" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["elasticbeanstalk.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "service" {
  for_each = local.service_permissions

  role       = aws_iam_role.service.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "this" {
  name = "aws-elasticbeanstalk-instance-profile"
  role = aws_iam_role.ec2_profile.name

  tags = merge(local.tags, { Resource = "ec2-instance-profile" })
}

resource "aws_iam_role" "ec2_profile" {
  name               = "aws-ec2-instance-profile"
  description        = "The IAM role to attach to an EC2 instance"
  assume_role_policy = data.aws_iam_policy_document.ec2_profile.json

  tags = merge(local.tags, { Resource = "ec2-role" })
}

data "aws_iam_policy_document" "ec2_profile" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ec2_profile" {
  for_each = local.instance_profile_permissions

  role       = aws_iam_role.ec2_profile.name
  policy_arn = each.value
}