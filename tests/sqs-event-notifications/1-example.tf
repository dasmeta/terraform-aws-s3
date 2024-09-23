module "private" {
  source = "../.."

  name = "dasmeta-dev-private"

  event_notification_config = {
    target_type   = "sqs"
    name_suffix   = "event"
    filter_prefix = "test/"
    events        = ["s3:ObjectCreated:CompleteMultipartUpload"]
  }
}

