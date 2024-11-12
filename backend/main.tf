locals {
  project = "vprofile"
  env     = "dev"

  tags = {
    Project     = local.project
    Environment = local.env
  }
}

provider "aws" {
  shared_credentials_files = var.shared_credentials
  shared_config_files      = var.shared_config
  profile                  = var.profile
}

module "sns" {
  source = "./modules/sns"

  project = local.project
  email   = var.email

  tags = local.tags
}

module "vpc" {
  source = "./modules/vpc"

  project = local.project
  env     = "dev"

  tags = local.tags
}

module "rds" {
  source = "./modules/rds"

  project = local.project
  env     = local.env

  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  rsg_ids             = [module.vpc.ssh_sg_id]
  sg_ids              = [module.vpc.out_sg_id]
  snapshot_identifier = var.db_snapshot_id

  tags = local.tags
}

module "mc" {
  source = "./modules/memcache"

  project    = local.project
  env        = local.env
  sg_ids     = [module.vpc.out_sg_id]
  vpc_id     = module.vpc.vpc_id
  rsg_ids    = [module.vpc.ssh_sg_id]
  subnet_ids = module.vpc.private_subnet_ids
  sns_arn    = module.sns.sns_topic_arn

  tags = local.tags
}

module "rmq" {
  source = "./modules/rmq"

  project    = local.project
  env        = local.env
  sg_ids     = [module.vpc.out_sg_id]
  subnet_ids = module.vpc.private_subnet_ids
  vpc_id     = module.vpc.vpc_id
  rsg_ids    = [module.vpc.ssh_sg_id]

  tags = local.tags
}