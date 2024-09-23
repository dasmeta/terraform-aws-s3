data "aws_iam_policy_document" "queue" {
  count = var.event-notification-config.target_type == "sqs" ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = ["arn:aws:sqs:*:*:${var.event-notification-config.queue_name}"]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [module.bucket.s3_bucket_arn]
    }
  }
}

resource "aws_sqs_queue" "queue" {
  count = var.event-notification-config.target_type == "sqs" ? 1 : 0

  name   = var.event-notification-config.queue_name
  policy = data.aws_iam_policy_document.queue[0].json
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  count = var.event-notification-config.target_type == "sqs" ? 1 : 0

  bucket = module.bucket.s3_bucket_id

  queue {
    queue_arn     = aws_sqs_queue.queue[0].arn
    events        = var.event-notification-config.events
    filter_prefix = var.event-notification-config.filter_prefix
  }
}
