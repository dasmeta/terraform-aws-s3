module "public" {
  source = "../.."

  name = "dasmeta-dev-public-1"
  acl  = "public"
}

module "public-read" {
  source = "../.."

  name = "dasmeta-dev-public-read-1"
  acl  = "public-read"
}
