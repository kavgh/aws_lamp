locals {
  project = "vprofile"
  env     = "dev"
  pkey    = "~/.ssh/aws_ec2.pub"

  tags = {
    Project     = local.project
    Environment = local.env
  }
}


resource "aws_key_pair" "this" {
  key_name   = "ssh-pub-key"
  public_key = file(local.pkey)

  tags = merge(local.tags, { Resource = "pub-key" })
}

module "s3" {
  source = "./modules/s3"

  project = local.project
  env     = local.env

  tags = local.tags
}

module "roles" {
  source = "./modules/roles"

  tags = local.tags
}

module "beanstalk" {
  source = "./modules/beanstalk"

  project              = local.project
  env                  = local.env
  vpc_id               = var.vpc_id
  subnet_ids           = var.public_subnet_ids
  key_pair             = aws_key_pair.this.id
  service_role_arn     = module.roles.service_role_arn
  instance_profile_arn = module.roles.instance_profile_arn
  bucket_name          = module.s3.bucket_name
  artifact_name        = module.s3.object_name
  sns_topic_arn        = var.sns_topic_arn
  sg_ids               = var.ec2_sg_ids
#  elb_sg_ids           = var.elb_sg_ids

  tags = local.tags
}

module "cloudfront" {
  source = "./modules/cdn"

  project = local.project
  env     = local.env
  url     = module.beanstalk.URL

  tags = local.tags
}