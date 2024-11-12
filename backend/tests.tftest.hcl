variables {
  project         = "vprofile"
  env             = "dev"
  db_name         = "accounts"
  name            = "${var.vprofile}-${var.env}"
  mc_param_name   = "vprofile-dev-memcached-pg"
  mc_sub_name     = "vprofile-dev-memcached-sub-gr"
  mc_cluster_name = "vprofile-dev-memcached-cluster"
}

run "vpc" {
  module {
    source = "./modules/vpc"
  }
}

run "rds" {
  #command = apply
  command = plan

  variables {
    rsg_id     = run.vpc.ssh_sg_id
    vpc_id     = run.vpc.vpc_id
    subnet_ids = run.vpc.private_subnet_ids
  }

  module {
    source = "./modules/rds"
  }

  assert {
    condition     = module.rds.db_instance_name == var.db_name
    error_message = "DB name not ${var.db_name}"
  }

  assert {
    condition     = module.rds.db_instance_username == "admin"
    error_message = "The initial DB username in the RDS instance is not accounts"
  }
}

run "mc" {
  #command = apply
  command = plan

  variables {
    rsg_id     = run.vpc.ssh_sg_id
    vpc_id     = run.vpc.vpc_id
    subnet_ids = run.vpc.private_subnet_ids
  }

  module {
    source = "./modules/memcache"
  }

  assert {
    condition     = module.elasticache.parameter_group_id == var.mc_param_name
    error_message = "The parameter group name not ${var.mc_param_name}"
  }

  assert {
    condition     = module.elasticache.subnet_group_name == var.mc_sub_name
    error_message = "The subnet group name not ${var.mc_param_name}"
  }

  #assert {
  #condition = aws_elasticache_cluster.this.cluster_id == var.mc_cluster_name
  #condition = module.mc.cluster_name == var.mc_cluster_name
  #error_message = "The cluster name not ${var.mc_cluster_name}"
  #}
}