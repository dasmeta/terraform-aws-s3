data "aws_iam_policy_document" "public" {
  count = local.is_public ? 1 : 0

  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.name}/*"]
  }
}
