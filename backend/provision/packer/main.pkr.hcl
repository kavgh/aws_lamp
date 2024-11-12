locals {
  tmp_path = "/tmp/"
}

source "amazon-ebs" "this" {
  shared_credentials_file = var.credentials_file
  region                  = var.region
  profile                 = var.profile

  ami_name      = "db-initializing"
  instance_type = "t2.micro"
  source_ami    = "ami-0862be96e41dcbf74"
  iam_instance_profile = var.iam_profile

  associate_public_ip_address = true
  subnet_id = var.subnet_id

  communicator         = "ssh"
  ssh_username         = "ubuntu"
  ssh_keypair_name     = var.pkey
  ssh_private_key_file = "~/.ssh/aws_ec2"

  tags = {
    temp   = "for initialization"
    delete = "true"
  }
}

build {
  sources = ["source.amazon-ebs.this"]

  provisioner "file" {
    source      = "${path.root}/resources/db_backup.sql"
    destination = local.tmp_path
  }

  #provisioner "file" {
  #  source = "${path.root}/resources/aws.gpg"
  #  destination = local.tmp_path
  #}

  provisioner "shell" {
    env = {
      DB_ENDPOINT = var.db_endpoint
      DB_USERNAME = var.db_username
      DB_NAME     = var.db_name
      DB_BACKUP   = "${local.tmp_path}db_backup.sql"
      DB_PORT = var.db_port
      DB_PASSWORD = var.db_password
      REGION = var.region
    }
    script = "${path.root}/resources/db_initialization.sh"
  }

  post-processor "manifest" {
    output = "db_initialization_manifest.json"
  }
}