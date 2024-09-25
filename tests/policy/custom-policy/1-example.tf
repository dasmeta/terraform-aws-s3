
provider "aws" {
  region = "eu-central-1"
}

module "custom-policies" {
  source = "../../.."

  acl  = "private"
  name = "policies-bucket-example-wpas-2"


  bucket_iam_policy = [
    {
      effect = "Allow"
      actions = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:ListBucket",
      ]
      principals = {
        type        = "AWS"
        identifiers = ["*"]
      }
      # conditions = [{
      #   value = [1.2]
      #   key   = "s3:TlsVersion"
      #   type  = "NumericLessThan"
      # }]
    }
  ]
}
