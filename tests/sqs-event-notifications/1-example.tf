module "private" {
  source = "../.."

  name = "dasmeta-dev-private"

  event-notification-config = {
    target_type   = "sqs"
    queue_name    = "test"
    filter_prefix = "test/"
    events        = ["s3:ObjectCreated:CompleteMultipartUpload"]
  }
}
