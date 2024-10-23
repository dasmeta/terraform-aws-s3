resource "aws_s3_bucket_intelligent_tiering_configuration" "bucket_intelligent_tiering" {
  count = length(var.bucket_intelligent_tiering) > 0 ? 1 : 0

  bucket = module.bucket.s3_bucket_id
  name   = "${module.bucket.s3_bucket_id}-intelligent-lifecycle"

  dynamic "tiering" {
    for_each = var.bucket_intelligent_tiering
    content {
      access_tier = tiering.value.tier
      days        = tiering.value.days
    }
  }

}
