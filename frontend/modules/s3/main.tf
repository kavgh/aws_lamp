locals {
  tags = merge(var.tags, { Service = "s3-bucket" })
}

resource "aws_s3_bucket" "this" {
  bucket = "s3-${var.project}-${var.env}-artifcats"

  tags = merge(local.tags, { Resource = "bucket" })
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json

  depends_on = [aws_s3_bucket_public_access_block.this]
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id
}

resource "aws_s3_object" "this" {
  bucket                 = aws_s3_bucket.this.id
  content_disposition    = "${var.project}-artifact"
  server_side_encryption = "AES256"
  acl                    = "private"
  key                    = "ROOT.war"
  checksum_algorithm     = "SHA256"
  source_hash            = filesha256("${path.module}/resources/ROOT.war")
  source                 = "${path.module}/resources/ROOT.war"

  tags = merge(local.tags, { Resource = "object" })
}

data "aws_caller_identity" "this" {}

data "aws_iam_policy_document" "this" {

  statement {
    effect    = "Deny"
    resources = ["${aws_s3_bucket.this.arn}/*", aws_s3_bucket.this.arn]
    actions = [
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:RestoreObject"
    ]

    not_principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::905418464140:user/terraform"]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["${aws_s3_bucket.this.arn}/*", aws_s3_bucket.this.arn]
    actions = [
      "s3:ListBucket",
      "s3:ListBucketVersions",
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}