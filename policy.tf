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

data "aws_iam_policy_document" "bucket_policy" {
  count = length(var.bucket_iam_policy) > 0 ? 1 : 0

  dynamic "statement" {
    for_each = var.bucket_iam_policy

    content {
      effect    = lookup(statement.value, "effect", "Allow")
      actions   = statement.value.actions
      resources = ["arn:aws:s3:::${var.name}", "arn:aws:s3:::${var.name}/*"]

      principals {
        type        = statement.value.principals.type
        identifiers = statement.value.principals.identifiers
      }

      dynamic "condition" {
        for_each = length(statement.value.conditions) > 0 ? statement.value.conditions : []

        content {
          test     = condition.value.type  # Condition type (e.g., StringEquals)
          variable = condition.value.key   # Condition variable (e.g., "SAML:aud")
          values   = condition.value.value # Condition values (list of strings)
        }
      }
    }
  }
}
