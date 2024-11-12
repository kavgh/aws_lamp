locals {
  origin_id       = "${var.project}-lb"
  allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "PATCH", "POST", "DELETE"]
  cached_methods  = ["GET", "HEAD"]

  tags = merge(var.tags, { Service = "cdn" })
}

resource "aws_cloudfront_distribution" "this" {
  enabled     = true
  comment     = "The CDN configuration for the ${var.project} application in ${var.env} environment"
  price_class = "PriceClass_All"

  origin {
    domain_name = var.url
    origin_id   = local.origin_id

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1"]
    }
  }

  default_cache_behavior {
    target_origin_id = local.origin_id

    allowed_methods        = local.allowed_methods
    cached_methods         = local.cached_methods
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = merge(local.tags, { Resource = "cloudfront" })
}