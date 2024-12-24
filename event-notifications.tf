data "aws_iam_policy_document" "queue" {
  count = var.event_notification_config.target_type == "sqs" ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = ["arn:aws:sqs:*:*:${local.queue_name}"]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [module.bucket.s3_bucket_arn]
    }
  }
}

resource "aws_sqs_queue" "queue" {
  count = var.event_notification_config.target_type == "sqs" ? 1 : 0

  name   = local.queue_name
  policy = data.aws_iam_policy_document.queue[0].json
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  count = var.event_notification_config.target_type == "sqs" ? 1 : 0

  bucket = module.bucket.s3_bucket_id

  queue {
    queue_arn     = aws_sqs_queue.queue[0].arn
    events        = var.event_notification_config.events
    filter_prefix = var.event_notification_config.filter_prefix
  }
}
