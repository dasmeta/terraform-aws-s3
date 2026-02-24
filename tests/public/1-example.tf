module "public" {
  source = "../.."

  name = "dasmeta-dev-public-2"
  acl  = "public"
}

module "public-read" {
  source = "../.."

  name = "dasmeta-dev-public-read-2"
  acl  = "public-read"
}
