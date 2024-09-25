module "private" {
  source = "../.."

  name = "dasmeta-dev-private"
}

module "private-explicitly" {
  source = "../.."

  name = "dasmeta-dev-private-explicitly"
  acl  = "private"

  cors_rule = [
    {
      allowed_methods = ["HEAD", "GET", "PUT", "POST"]
      allowed_origins = ["https://modules.tf", "https://dasmeta.modules.tf"]
      allowed_headers = ["*"]
      expose_headers  = ["ETag", "Access-Control-Allow-Origin"]
    }
  ]
}
