locals {
  name = "${var.project}-sns"
  tags = merge(var.tags, { Service = "sns" })
}

resource "aws_sns_topic" "this" {
  name = "${local.name}-topic"

  tags = merge(local.tags, { Resource = "topic" })
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.email
}