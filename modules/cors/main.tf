resource "aws_s3_bucket_cors_configuration" "this" {
  bucket                = var.bucket
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "cors_rule" {
    for_each = var.cors_rule

    content {
      id              = cors_rule.value.id
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      allowed_headers = cors_rule.value.allowed_headers
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}
