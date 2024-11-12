locals {
  name = var.project

  tags = merge(var.tags, { Service = "beanstalk" })

  settings = [
    { namespace = "aws:autoscaling:asg", name = "MinSize", value = "2" },
    { namespace = "aws:autoscaling:asg", name = "MaxSize", value = "4" },
    { namespace = "aws:autoscaling:asg", name = "Cooldown", value = "180" },
    { namespace = "aws:autoscaling:launchconfiguration", name = "EC2KeyName", value = var.key_pair },
    { namespace = "aws:autoscaling:launchconfiguration", name = "IamInstanceProfile", value = var.instance_profile_arn },
    { namespace = "aws:autoscaling:launchconfiguration", name = "SecurityGroups", value = join(",", var.sg_ids) },
    { namespace = "aws:autoscaling:launchconfiguration", name = "RootVolumeType", value = "gp2" },
    { namespace = "aws:autoscaling:launchconfiguration", name = "RootVolumeSize", value = "8" },
    { namespace = "aws:autoscaling:trigger", name = "EvaluationPeriods", value = "3" },
    { namespace = "aws:autoscaling:updatepolicy:rollingupdate", name = "MinInstancesInService", value = "1" },
    { namespace = "aws:autoscaling:updatepolicy:rollingupdate", name = "RollingUpdateType", value = "Health" },
    { namespace = "aws:autoscaling:updatepolicy:rollingupdate", name = "RollingUpdateEnabled", value = "true" },
    { namespace = "aws:ec2:instances", name = "InstanceTypes", value = "t3.micro" },
    { namespace = "aws:ec2:instances", name = "SupportedArchitectures", value = "x86_64" },
    { namespace = "aws:ec2:vpc", name = "VPCId", value = var.vpc_id },
    { namespace = "aws:ec2:vpc", name = "Subnets", value = join(",", var.subnet_ids) },
    { namespace = "aws:ec2:vpc", name = "ELBSubnets", value = join(",", var.subnet_ids) },
    { namespace = "aws:ec2:vpc", name = "AssociatePublicIpAddress", value = "true" },
    { namespace = "aws:elasticbeanstalk:application", name = "Application Healthcheck URL", value = "/login" },
    { namespace = "aws:elasticbeanstalk:command", name = "DeploymentPolicy", value = "Rolling" },
    { namespace = "aws:elasticbeanstalk:command", name = "Timeout", value = "60" },
    { namespace = "aws:elasticbeanstalk:command", name = "BatchSize", value = "50" },
    { namespace = "aws:elasticbeanstalk:environment", name = "ServiceRole", value = var.service_role_arn },
    { namespace = "aws:elasticbeanstalk:environment", name = "LoadBalancerType", value = var.elb_type },
    { namespace = "aws:elasticbeanstalk:environment:process:default", name = "HealthCheckPath", value = "/login" },
    { namespace = "aws:elasticbeanstalk:environment:process:default", name = "StickinessEnabled", value = "true" },
    { namespace = "aws:elasticbeanstalk:environment:process:default", name = "UnhealthyThresholdCount", value = "3" },
    { namespace = "aws:elasticbeanstalk:healthreporting:system", name = "SystemType", value = "enhanced" },
    { namespace = "aws:elasticbeanstalk:sns:topics", name = "Notification Topic ARN", value = var.sns_topic_arn },
    { namespace = "aws:elb:healthcheck", name = "UnhealthyThreshold", value = "3" },
    { namespace = "aws:elb:loadbalancer", name = "SecurityGroups", value = join(",", var.elb_sg_ids) },
    { namespace = "aws:elasticbeanstalk:application:environment", name = "S3_BUCKET_NAME", value = var.bucket_name },
    { namespace = "aws:elasticbeanstalk:application:environment", name = "S3_BUCKET_KEY", value = var.artifact_name }
  ]
}

resource "aws_elastic_beanstalk_application" "this" {
  name        = "${local.name}-app"
  description = "The ${var.project} application"

  tags = merge(local.tags, { Resource = "application" })
}

resource "aws_elastic_beanstalk_application_version" "this" {
  name        = "Sample"
  application = aws_elastic_beanstalk_application.this.name
  bucket      = var.bucket_name
  key         = var.artifact_name
  description = "The ${local.name} application 0.1.0 version"

  tags = merge(local.tags, { Resource = "application", Version = "0.1.0" })

  depends_on = [aws_elastic_beanstalk_environment.this]
}

resource "aws_elastic_beanstalk_environment" "this" {
  name                = "${local.name}-${var.env}"
  description         = "The ${var.project} application in the ${var.env} environment"
  application         = aws_elastic_beanstalk_application.this.name
  tier                = var.tier
  solution_stack_name = var.solution_stack_name

  dynamic "setting" {
    for_each = local.settings

    content {
      namespace = setting.value.namespace
      name      = setting.value.name
      value     = setting.value.value
    }
  }

  tags = merge(local.tags, { Resource = "environment" })
}