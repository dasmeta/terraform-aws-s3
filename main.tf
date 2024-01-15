locals {
  # do not enable public acl if only public is requested (this is to not modify the interface)
  acl = var.acl == "public" ? "null" : var.acl

  is_public = strcontains(var.acl, "public")
}

module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.0.1"

  bucket                   = var.name
  acl                      = local.acl
  ignore_public_acls       = var.ignore_public_acls
  restrict_public_buckets  = var.restrict_public_buckets
  block_public_acls        = var.block_public_acls
  block_public_policy      = var.block_public_policy
  control_object_ownership = var.acl != null ? true : false

  versioning = var.versioning

  website = var.website

  policy        = local.is_public ? data.aws_iam_policy_document.public[0].json : ""
  attach_policy = local.is_public
}

// have initial index.html file content
resource "aws_s3_object" "index" {
  count = var.create_index_html ? 1 : 0

  bucket       = module.bucket.s3_bucket_id
  key          = "index.html"
  content      = "OK, ${module.bucket.s3_bucket_id}"
  acl          = "public-read"
  content_type = "text/html"

  lifecycle {
    ignore_changes = [
      content
    ]
  }
}

// have/create some more init files into bucket
module "bucket_files" {
  source = "./objects"

  count = try(var.bucket_files.path, "") != "" ? 1 : 0

  bucket  = module.bucket.s3_bucket_id
  path    = var.bucket_files.path
  acl     = try(var.bucket_files.acl, "public-read")
  pattern = try(var.bucket_files.pattern, "**")
}
